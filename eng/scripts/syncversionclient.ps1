# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License.

param(
    [Parameter(Mandatory = $false)][string]$GroupId = "com.azure"
)

Write-Information "PS Script Root is: $PSScriptRoot"

$RepoRoot = Resolve-Path "${PSScriptRoot}..\..\.."
$EngDir = Join-Path $RepoRoot "eng"
$EngVersioningDir = Join-Path $EngDir "versioning"
$EngCommonScriptsDir = Join-Path $EngDir "common" "scripts"

. (Join-Path $EngCommonScriptsDir common.ps1)

class MavenArtifactInfo {
    [String] $GroupId
    [String] $Name
    [String] $LatestGAOrPatchVersion
    [String] $LatestRealeasedVersion

    MavenArtifactInfo($Name, $LatestGAOrPatchVersion, $LatestRealeasedVersion) {
        $this.Name = $Name
        $this.LatestGAOrPatchVersion = $LatestGAOrPatchVersion
        $this.LatestRealeasedVersion = $LatestRealeasedVersion
        $this.GroupId = 'com.azure'
    }
}

function UpdateDependencyVersion([MavenArtifactInfo]$ArtifactInfo, [EngSysVersionInfo]$EngSysVersionInfo) {
    $setVersionFilePath = Join-Path $EngVersioningDir "set_versions.py"

    $version = $ArtifactInfo.LatestGAOrPatchVersion
    $sdkName = $ArtifactInfo.Name
    $groupId = $ArtifactInfo.GroupId
    $engsysCurrentVersion = $EngSysVersionInfo.CurrentVersion

    if([String]::IsNullOrWhiteSpace($version)) {
        return
    }

    $cmdOutput = python $setVersionFilePath --bt client --new-version $version --ar $sdkName --gi $groupId
    $cmdOutput = python $setVersionFilePath --bt client --ar $sdkName --gi $groupId --increment-version
    $cmdOutput = python $setVersionFilePath --bt client --new-version $engsysCurrentVersion --ar $sdkName --gi $groupId
}

function UpdateDependencyOfClientSDK() {
    $UpdateVersionFilePath = Join-Path $EngVersioningDir "update_versions.py"
    $cmdOutput = python $UpdateVersionFilePath --ut all --bt client --sr
}

function GetAllArtifactsFromMaven([String]$GroupId) {
    $webResponseObj = Invoke-WebRequest -Uri "https://repo1.maven.org/maven2/com/azure"
    $azureComArtifactIds = $webResponseObj.Links.HRef | Where-Object { ($_ -like 'azure-*') -and ($IgnoreList -notcontains $_) } |  ForEach-Object { $_.substring(0, $_.length - 1) }
    return $azureComArtifactIds | Where-Object {($_ -like "azure-*") -and !($_ -like "azure-spring")}
}

function GetVersionInfoForAnArtifactId([String]$ArtifactId){
    $mavenMetadataUrl = "https://repo1.maven.org/maven2/com/azure/$($ArtifactId)/maven-metadata.xml"
    $webResponseObj = Invoke-WebRequest -Uri $mavenMetadataUrl
    $versions = ([xml]$webResponseObj.Content).metadata.versioning.versions.version
    $semVersions = $versions | ForEach-Object { [AzureEngSemanticVersion]::ParseVersionString($_) }
    $sortedVersions = [AzureEngSemanticVersion]::SortVersions($semVersions)
    $latestReleasedVersion = $sortedVersions[0].RawVersion
    $latestPatchOrGAVersion = $sortedVersions | Where-Object { !($_.IsPrerelease) } | ForEach-Object { $_.RawVersion } | Select-Object -First 1
    
    $mavenArtifactInfo = [MavenArtifactInfo]::new($ArtifactId, $latestPatchOrGAVersion, $latestReleasedVersion)

    return $mavenArtifactInfo
}

class EngSysVersionInfo{
    [String] $GroupId
    [String] $Name
    [String] $DependencyVersion
    [String] $CurrentVersion

    EngSysVersionInfo($Name, $DependencyVersion, $CurrentVersion) {
        $this.Name = $Name
        $this.DependencyVersion = $DependencyVersion
        $this.CurrentVersion = $CurrentVersion
        $this.GroupId = 'com.azure'
    }
}

function ParseVersionClientFile($GroudpId) {
    $versionClientInfo = @{}
    $versionClientFilePath = Join-Path $EngVersioningDir "version_client.txt"
    $regexPattern = "$($GroupId):(.*);(.*);(.*)"

    foreach($line in Get-Content $versionClientFilePath) {
        if($line -match $regexPattern) {
            $artifactId = $Matches.1
            $dependencyVersion = $Matches.2
            $currentVersion = $Matches.3

            $engSysVersionInfo = [EngSysVersionInfo]::new($artifactId, $dependencyVersion, $currentVersion)
            $versionClientInfo[$artifactId] = $engSysVersionInfo
        }
    }

    return $versionClientInfo

}

function SyncVersionClientFile([String]$GroupId) {
    $artifactIds = GetAllArtifactsFromMaven -GroupId $GroupId
    $versionClientInfo = ParseVersionClientFile -GroudpId $GroupId

    foreach($artifactId in $artifactIds) {
        $artifactInfo = GetVersionInfoForAnArtifactId -ArtifactId $artifactId
        $latestPatchOrGaVersion = $ArtifactInfo.LatestGAOrPatchVersion
        
        if([String]::IsNullOrWhiteSpace($latestPatchOrGaVersion)) {
            # This library does not have a released version so we are likely good here.
            continue
        }

        $engSysArtifactInfo = $versionClientInfo[$artifactId]
        if($null -eq $engSysArtifactInfo) {
            continue
        }

        $dependencyVersion = $engSysArtifactInfo.DependencyVersion;
        if($dependencyVersion -eq $latestPatchOrGaVersion) {
            continue
        }

        UpdateDependencyVersion -ArtifactInfo $artifactInfo -EngSysVersionInfo $engSysArtifactInfo
        UpdateDependencyOfClientSDK
    }
}






