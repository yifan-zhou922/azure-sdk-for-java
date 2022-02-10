# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License.

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

. Join-Path ${PSScriptRoot} "common.ps1"

function UpdateDependencyVersion($GroupId, $ArtifactName, $Version) {
    $repoRoot = Resolve-Path "${PSScriptRoot}..\..\.."
    $setVersionFilePath = Join-Path $repoRoot "eng" "versioning" "set_versions.py"
    $cmdOutput = python $setVersionFilePath --bt client --new-version $Version --ar $ArtifactName --gi $GroupId
    $cmdOutput = python $setVersionFilePath --bt client --ar $ArtifactName --gi $GroupId --increment-version
}

function UpdateCurrentVersion($GroupId, $ArtifactName, $Version) {
    $repoRoot = Resolve-Path "${PSScriptRoot}..\..\.."
    $setVersionFilePath = Join-Path $repoRoot "eng" "versioning" "set_versions.py"
    $cmdOutput = python $setVersionFilePath --bt client --new-version $Version --ar $ArtifactName --gi $GroupId
}

function UpdateDependencyOfClientSDK() {
    $UpdateVersionFilePath = Join-Path $EngVersioningDir "update_versions.py"
    $cmdOutput = python $UpdateVersionFilePath --ut all --bt client --sr
}

function GetAllArtifactsFromMaven([String]$GroupId) {
    $webResponseObj = Invoke-WebRequest -Uri "https://repo1.maven.org/maven2/com/azure"
    $azureComArtifactIds = $webResponseObj.Links.HRef | Where-Object { ($_ -like 'azure-*') -and ($IgnoreList -notcontains $_) } |  ForEach-Object { $_.substring(0, $_.length - 1) }
    return $azureComArtifactIds | Where-Object { ($_ -like "azure-*") -and !($_ -like "azure-spring") }
}

function GetVersionInfoForAnArtifactId([String]$ArtifactId) {
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

function GetVersionInfoForAllMavenArtifacts([string]$GroudpId) {
    $artifactInfos = @{}
    $azureComArtifacts = GetAllArtifactsFromMaven -GroupId $GroudpId

    foreach ($artifact in $azureComArtifacts) {
        $artifactInfo = GetVersionInfoForAnArtifactId -ArtifactId $artifact
        $artifactInfos[$artifact] = $artifactInfo
    }

    return $artifactInfos
}

function GetPatchVersion([String]$ReleaseVersion) {
    $ParsedSemver = [AzureEngSemanticVersion]::new($ReleaseVersion)
    if (!$ParsedSemver) {
        LogError "Unexpected release version:$($ReleaseVersion).Exiting..."
        exit 1
    }

    return "$($ParsedSemver.Major).$($ParsedSemver.Minor).$($ParsedSemver.Patch + 1)"
}

function GetRemoteName() {
    $mainRemoteUrl = 'https://github.com/Azure/azure-sdk-for-java.git'
    foreach ($rem in git remote show) {
        $remoteUrl = git remote get-url $rem
        if ($remoteUrl -eq $mainRemoteUrl) {
            return $remoteName
        }
    }
    LogError "Could not compute the remote name."
    return $null
}

function GetBranchName($ArtifactName, $Version) {
    $artifactNameToLower = $ArtifactName.ToLower()
    $guid = [guid]::NewGuid().Guid
    return "release/$($artifactNameToLower)_$($PatchVersion)_$($guid)"
}