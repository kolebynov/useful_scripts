Import-Module $PSScriptRoot\_Definitions.ps1
Import-Module $PSScriptRoot\GetCustomerLogsFolder.ps1
Import-Module $PSScriptRoot\ExtractGflPack.ps1

#============================================================================
# Extract case gflpack to specified folder
#============================================================================
function Extract-CaseGflPack() {
    [cmdletbinding()]
    param (
        [Parameter(Mandatory)]
        [string] $CustomerAccount,

        [Parameter(Mandatory)]
        [string] $CaseNumber,

        [string] $Destination = ".\",

        [string] $CustomerIndexPath = $CustomerIndexDefaultPath
    )

    $caseFolderPath = Get-CustomerLogsFolder $CustomerAccount $CaseNumber $CustomerIndexPath

    $gflPaths = Get-ChildItem $caseFolderPath\*.gfl -Verbose:$VerbosePreference -Debug:$DebugPreference
    $destinationFullPath = [System.IO.Path]::GetFullPath($Destination)

    foreach ($gflPath in $gflPaths) {
        Extract-GflPack $gflPath $destinationFullPath\$CustomerAccount\$CaseNumber\$([System.IO.Path]::GetFileNameWithoutExtension($gflPath.Name))
    }
}