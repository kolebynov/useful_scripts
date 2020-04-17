Import-Module $PSScriptRoot\_Definitions.ps1
Import-Module $PSScriptRoot\GetCustomerLogsFolder.ps1

#============================================================================
# Copy logs from customer index into specified folder
#============================================================================
function Copy-CustomerLogs() {
    [cmdletbinding()]
    param (
        [Parameter(Mandatory)]
        [string] $CustomerAccount,

        [Parameter(Mandatory)]
        [string] $CaseNumber,

        [string] $Destination = ".",

        [string] $CustomerIndexPath = $CustomerIndexDefaultPath
    )

    $caseFolderPath = Get-CustomerLogsFolder $CustomerAccount $CaseNumber $CustomerIndexPath

    Write-Host "Copying $($(Get-ChildItem $caseFolderPath -Recurse | Measure-Object Length -Sum).Sum / 1KB) KB from $caseFolderPath"

    Copy-Item -Path $caseFolderPath -Destination "$Destination\$CustomerAccount" -Force -Recurse -Verbose:$VerbosePreference -Debug:$DebugPreference
}