# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License.

param(
    [string]$GroupId = "com.azure"
)

Write-Information "PS Script Root is: $PSScriptRoot"
$RepoRoot = Resolve-Path "${PSScriptRoot}..\..\.."

. (Join-Path $RepoRoot "eng" "common" "scripts" common.ps1)
. (Join-Path $PSScriptRoot bomhelpers.ps1)

function ComputeDependencyGraph($ArtifactInfos) {
    $artifactDetails = @{}
    foreach ($sdkName in $ArtifactInfos.Keys) {
        $deps = @{}
        $sdkVersion = $ArtifactInfos[$sdkName].LatestGAOrPatchVersion
        $pomFileUri = "https://repo1.maven.org/maven2/com/azure/$($sdkName)/$($sdkVersion)/$($sdkName)-$($sdkVersion).pom"
        $webResponseObj = Invoke-WebRequest -Uri $pomFileUri
        $dependencies = ([xml]$webResponseObj.Content).project.dependencies.dependency | Where-Object { (([String]::IsNullOrWhiteSpace($_.scope)) -or ($_.scope -eq 'compile')) }
        $dependencies | Where-Object { $_.groupId -eq $GroupId } | ForEach-Object { $deps[$_.artifactId] = $_.version }
        $artifactDetails[$sdkName] = [ArtifactDetails]::new($sdkName, $sdkVersion, $deps)
    }

    return $artifactDetails
}

function EagerPatchEvaluator([String]$ArtifactName, [String]$PatchVersion, [hashtable]$ArtifactDetails) {
    $artifactsToPatch = [System.Collections.Generic.List[PatchInfo]]::new()
    foreach ($sdkName in $ArtifactDetails.Keys) {
        $artifact = $ArtifactDetails[$sdkName]
        $artifactVersion = $artifact.Dependencies[$ArtifactName]

        if ($artifactVersion -and $artifactVersion -ne $PatchVersion) {
            $latestGAOrPatchVersion = $artifact.LatestPatchOrGAVersion
            $artifactPatchVersion = GetPatchVersion -ReleaseVersion $latestGAOrPatchVersion
            $artifactsToPatch.Add([PatchInfo]::new($sdkName, $latestGAOrPatchVersion, $artifactPatchVersion))
            $recArtifactsToPatch = EagerPatchEvaluator -ArtifactName $sdkName -PatchVersion $artifactPatchVersion -ArtifactDetails $ArtifactDetails
            foreach ($recArtifacts in $recArtifactsToPatch) {
                $artifactsToPatch.Add($recArtifacts)
            }
        }
    }

    return $artifactsToPatch
}

function UpdateDependencies([PatchInfo]$ArtifactPatchInfo, $ArtifactPatchInfos, [hashtable]$ArtifactInfoDetails) {
    ## We need to update the version_client.txt to have the correct versions in place.
    $patchArtifactName = $ArtifactPatchInfo.Name
    $dependencies = $ArtifactInfoDetails[$patchArtifactName].Dependencies
    foreach ($depName in $dependencies.Keys) {
        $dependencyVersion = $ArtifactPatchInfos | Where-Object { $_.Name -eq $depName } | Select-Object { $_.PatchVersion } -First 1

        if (!$dependencyVersion) {
            $dependencyVersion = $ArtifactInfoDetails[$depName].LatestPatchOrGAVersion
        }

        if ($dependencyVersion) {
            $cmdOutput = UpdateDependencyVersion -GroupId $GroupId -ArtifactName $depName -Version $dependencyVersion   
        }
    }
}

function UndoVersionClientFile() {
    $repoRoot = Resolve-Path "${PSScriptRoot}..\..\.."
    $versionClientFile = Join-Path $repoRoot "eng" "versioning" "version_client.txt"
    $cmdOutput = git checkout $versionClientFile
}

class ArtifactDetails {
    [string]$Name
    [string]$LatestPatchOrGAVersion
    [hashtable]$Dependencies

    ArtifactDetails($Name, $LatestPatchOrGAVersion, $Dependencies) {
        $this.Name = $Name
        $this.LatestPatchOrGAVersion = $LatestPatchOrGAVersion
        $this.Dependencies = $Dependencies
    }
}

class PatchInfo {
    [string]$Name
    [string]$ReleaseVersion
    [string]$PatchVersion

    PatchInfo($Name, $ReleaseVersion) {
        $this.Name = $Name
        $this.ReleaseVersion = $ReleaseVersion
        $this.PatchVersion = GetPatchVersion -ReleaseVersion $ReleaseVersion
    }

    PatchInfo($Name, $ReleaseVersion, $PatchVersion) {
        $this.Name = $Name
        $this.ReleaseVersion = $ReleaseVersion
        $this.PatchVersion = $PatchVersion
    }
}

$ArtifactInfos = GetVersionInfoForAllMavenArtifacts -GroupId $GroupId
$IgnoreList = @(
    'azure-client-sdk-parent',
    'azure-core-parent',
    'azure-core-test',
    'azure-sdk-all',
    'azure-sdk-bom',
    'azure-sdk-parent',
    'azure-sdk-template',
    'azure-sdk-template-bom',
    'azure-data-sdk-parent',
    'azure-spring-data-cosmos',
    'azure-core-management'
)

$inEligibleKeys = @()

# Remove ignore list and libraries that have not been GA'ed.
foreach ($key in $ArtifactInfos.Keys) {
    if ($IgnoreList -contains $key) {
        $inEligibleKeys += $key
        continue
    }

    $latestGAOrPatchVersion = $ArtifactInfos[$key].LatestGAOrPatchVersion
    if ([string]::IsNullOrWhiteSpace($latestGAOrPatchVersion)) {
        $inEligibleKeys += $key
        continue
    }
}

$inEligibleKeys | ForEach-Object { $ArtifactInfos.Remove($_) }

$ArtifactDetails = ComputeDependencyGraph -ArtifactInfos $ArtifactInfos
$AzCoreArtifactId = "azure-core"
$AzCoreVersion = $ArtifactDetails[$AzCoreArtifactId].LatestPatchOrGAVersion

$ArtifactsToPatch = EagerPatchEvaluator -ArtifactName $AzCoreArtifactId -PatchVersion $AzCoreVersion -ArtifactDetails $ArtifactDetails
$ArtifactsToPatch = $ArtifactsToPatch | Sort-Object Name -Unique

$RemoteName = GetRemoteName
$CurrentBranchName = git rev-parse --abbrev-ref HEAD
if ($LASTEXITCODE -ne 0) {
    LogError "Could not correctly get the current branch name."
    exit 1
}

$fileContent = [System.Text.StringBuilder]::new()
$fileContent.AppendLine("ArtifactId;BranchName");
## We now can run the generate_patch script for all those dependencies.
foreach ($patchArtifact in $ArtifactsToPatch) {
    try {
        UpdateDependencies -ArtifactPatchInfo $patchArtifact -ArtifactPatchInfos $ArtifactsToPatch -ArtifactInfoDetails $ArtifactDetails
        $remoteBranchName = GetBranchName -ArtifactName $patchArtifact.Name -Version $patchArtifact.PatchVersion
        Write-Output ./Generate-Patch.ps1 -ArtifactName $patchArtifact.Name -ReleaseVersion $patchArtifact.ReleaseVersion -BranchName $remoteBranchName -PushToRemote:$true -CreateNewBranch:$true
        $fileContent.AppendLine("$($patchArtifact.Name);$($remoteBranchName)");
        UndoVersionClientFile
    }
    finally {
        $cmdOutput = git checkout $CurrentBranchName
    }
}

New-Item -Path . -Name "ReleasePatchInfo.csv" -ItemType "file" -Value $fileContent.ToString() -Force



