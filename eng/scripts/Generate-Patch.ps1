# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License.

#Requires -Version 6.0

<#
.SYNOPSIS
This script will generate a patch release for a given artifact or service directory.

.DESCRIPTION
This script will do a number of things when ran:

- It will find the latest GA\patch version from the artifactId and will have you confirm if that is the release version you want to pick for the patch release.
- It will reset the sources to the release version picked above.
- It will update the compile time dependencies used by the given artifact.
- It will update the changelog and readme to point to the new version.

.PARAMETER ArtifactName
The artifact id. The script currently assumes groupId is com.azure

.PARAMETER ServiceDirectoryName
Optional: Provide a service directory to scope the search of the entire repo to speed-up the project search. This should be the directory
name under the 'sdk' folder (i.e for the core package which lives under 'sdk\core' the value to pass would be 'core').

.PARAMETER ReleaseVersion
Optional: Provide the release version against which the patch version will be prepared. If not provided it looks at the maven repo and builds a patch against the 
latest GA or patch release of the artifact.

.PARAMETER BranchName
Optional: The name of the remote branch where the patch changes will be pushed. This is not a required parameter. In case the argument is not provided 
the branch name is release/{ArtifactName}_{ReleaseVersion}. The script pushes the branch to remote URL https://github.com/Azure/azure-sdk-for-java.git

.PARAMETER PushToRemote
Optional: Whether the commited changes should be pushed to the remote branch or not.The default value is false.

.PARAMETER CreateNewBranch
Optional: Whether to create a new branch or use an existing branch. You would want to use an existing branch if you are using the same release tag for multiple libraries.

.EXAMPLE
PS> ./eng/scripts/Generate-Patch.ps1 -ArtifactName azure-mixedreality-remoterendering
This creates a remote branch "release/azure-mixedreality-remoterendering" with all the necessary changes.

The most common usage is to call the script passing the package name. Once the script is finished then you will have modified project and change log files.
You should make any additional changes to the change log to capture the changes and then submit the PR for the final changes before you do a release.
#>

param(
  [Parameter(Mandatory = $true)][string]$ArtifactName,
  [string]$ServiceDirectoryName,
  [string]$ReleaseVersion,
  [string]$BranchName,
  [boolean]$PushToRemote = $false,
  [boolean]$CreateNewBranch = $false
)

$RepoRoot = Resolve-Path "${PSScriptRoot}..\..\.."
. (Join-Path $RepoRoot "eng" "common" "scripts" common.ps1)
. (Join-Path ${PSScriptRoot} syncversionclient.ps1)
. (Join-Path $PSScriptRoot bomhelpers.ps1)

function TestPathThrow($Path, $PathName) {
  if (!(Test-Path $Path)) {
    LogError "$($PathName): $($Path) not found. Exiting ..."
    exit 1
  }
}

function GetDependencyToVersion($PomFilePath) {
  $dependencyNameToVersion = @{}
  $pomFileContent = [xml](Get-Content -Path $PomFilePath)
  foreach ($dependency in $pomFileContent.project.dependencies.dependency) {
    $scope = $dependency.scope
    if ($scope -ne 'test') {
      $dependencyNameToVersion[$dependency.artifactId] = $dependency.version
    }
  }

  return $dependencyNameToVersion
}

function GetChangeLogContent($NewDependencyNameToVersion, $OldDependencyNameToVersion) {
  $content = @()
  $content += ""
  $content += "### Other Changes"
  $content += ""
  $content += "#### Dependency Updates"
  $content += ""
  
  foreach ($key in $OldDependencyNameToVersion.Keys) {
    $oldVersion = $($OldDependencyNameToVersion[$key]).Trim()
    $newVersion = $($NewDependencyNameToVersion[$key]).Trim()
    if ($oldVersion -ne $newVersion) {
      $content += "- Upgraded ``$key`` from ``$oldVersion`` to version ``$newVersion``."
    }
  }
  
  $content += ""

  return $content
}

function GitCommit($Message) {
  $cmdOutput = git commit -a -m $Message
  if ($LASTEXITCODE -ne 0) {
    LogError "Could not commit the changes locally.Exiting..."
    exit 1
  }
}

if ([String]::IsNullOrWhiteSpace($ArtifactName)) {
  LogError "ArtifactName can't be null or whitespace"
  exit 1
}

if ([String]::IsNullOrWhiteSpace($ReleaseVersion)) {
  Write-Output "ReleaseVersion was not provided. Picking up the latest release version from maven central."
  $mavenArtifactInfo = [MavenArtifactInfo](GetVersionInfoForAnArtifactId -ArtifactId $ArtifactName)

  if ($null -eq $mavenArtifactInfo -or [String]::IsNullOrWhiteSpace($mavenArtifactInfo.LatestGAOrPatchVersion)) {
    LogError "Could not find $($ArtifactName) on maven central."
    exit 1
  }

  $mavenLatestReleaseVersion = $mavenArtifactInfo.LatestGAOrPatchVersion

  if ([String]::IsNullOrWhiteSpace($mavenLatestReleaseVersion)) {
    LogError "Could not compute the latest GA\release version for $($ArtifactName) from maven central. Exiting."
    exit 1
  }

  $ReleaseVersion = $mavenArtifactInfo.LatestGAOrPatchVersion
  Write-Output "Found the latest GA/Patch version $($ReleaseVersion). Using this to prepare the patch."  
}


$PatchVersion = GetPatchVersion -ReleaseVersion $ReleaseVersion
Write-Output "PatchVersion is: $PatchVersion"

$RemoteName = GetRemoteName
if(!$RemoteName) {
LogError "Could not compute the remote name."
exit 1
}
Write-Output "RemoteName is: $RemoteName"

if (!$BranchName) {
  $BranchName = GetBranchName -ArtifactName $ArtifactName -Version $PatchVersion

  if(!$BranchName) {
    LogError "Could not compute the branch name."
    exit 1    
  }
  Write-Output "Using branch: $($BranchName)"
}

## Creating a new branch
if ($CreateNewBranch) {
  $cmdOutput = git checkout -b $BranchName $RemoteName/main
}
else {
  $cmdOutput = git checkout $BranchName
}
if ($LASTEXITCODE -ne 0) {
  LogError "Could not checkout branch $($BranchName), please check if it already exists and delete as necessary. Exiting..."
  exit 1
}

$ReleaseTag = "${ArtifactName}_${ReleaseVersion}"
$PkgProperties = [PackageProps](Get-PkgProperties -PackageName $ArtifactName -ServiceDirectory $ServiceDirectoryName)
$ArtifactDirPath = $PkgProperties.DirectoryPath  
$CurrentPackageVersion = $PkgProperties.Version
if ($CurrentPackageVersion -ne $ReleaseVersion) {
  Write-Output "Hard reseting the sources for $($ArtifactName) to version $($ReleaseVersion) using release tag: $($ReleaseTag)." 
  Write-Information "Fetching all the tags from $RemoteName"
  $CmdOutput = git fetch $RemoteName $ReleaseTag
    
  if ($LASTEXITCODE -ne 0) {
    LogError "Could not restore the tags for release tag $($ReleaseTag)"
    exit 1
  }
  
  $cmdOutput = git restore --source $ReleaseTag -W -S $ArtifactDirPath
  if ($LASTEXITCODE -ne 0) {
    LogError "Could not reset sources for $($ArtifactName) to the release version $($ReleaseVersion)"
    exit 1
  }

  ## Commit these changes.
  GitCommit -Message "Reset sources for $($ArtifactName) to the release version $($ReleaseVersion)."
}
  
  $SetVersionFilePath = Join-Path $EngVersioningDir "set_versions.py"
  $UpdateVersionFilePath = Join-Path $EngVersioningDir "update_versions.py"
  $PomFilePath = Join-Path $PkgProperties.DirectoryPath "pom.xml"
  $OldDependencyNameToVersion = GetDependencyToVersion -PomFilePath $PomFilePath
  $cmdOutput = python $SetVersionFilePath --bt client --new-version $PatchVersion --ar $ArtifactName --gi $GroupId
  if ($LASTEXITCODE -ne 0) {
    LogError "Could not set the dependencies for $($ArtifactName)"
    exit 1
  }
  
  $cmdOutput = python $UpdateVersionFilePath --ut all --bt client --sr
  if ($LASTEXITCODE -ne 0) {
    LogError  LogError "Could not set the dependencies for $($ArtifactName)"
    exit 1
  }
  
  $ChangelogPath = $PkgProperties.ChangeLogPath
  $NewDependenciesToVersion = GetDependencyToVersion -PomFilePath $PomFilePath
  $ReleaseStatus = "$(Get-Date -Format $CHANGELOG_DATE_FORMAT)"
  $ReleaseStatus = "($ReleaseStatus)"
  $ChangeLogEntries = Get-ChangeLogEntries -ChangeLogLocation $ChangelogPath

  $Content = GetChangeLogContent -NewDependencyNameToVersion $NewDependenciesToVersion -OldDependencyNameToVersion $OldDependencyNameToVersion
  $NewChangeLogEntry = New-ChangeLogEntry -Version $PatchVersion -Status $ReleaseStatus -Content $Content
  if ($NewChangeLogEntry) {
    $ChangeLogEntries.Insert(0, $PatchVersion, $NewChangeLogEntry)
  }
  else {
    LogError "Failed to create new changelog entry for $($ArtifactName)"
    exit 1
  }

  $cmdOutput = Set-ChangeLogContent -ChangeLogLocation $ChangelogPath -ChangeLogEntries $ChangeLogEntries
  if ($LASTEXITCODE -ne 0) {
    LogError "Could not update the changelog at $($ChangelogPath). Exiting..."
    exit 1
  }

  GitCommit -Message "Prepare $($ArtifactName) for $($PatchVersion) patch release."
  if ($PushToRemote) {
    $cmdOutput = git push $RemoteName $BranchName
    if ($LASTEXITCODE -ne 0) {
      LogError "Could not push the changes to $($RemoteName)\$($BranchName). Exiting..."
      exit 1
    }
    Write-Output "Pushed the changes to remote:$($RemoteName), Branch:$($BranchName))"
  }

Write-Output "Patch generation completed successfully."