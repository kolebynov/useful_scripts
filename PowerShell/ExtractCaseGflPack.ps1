Import-Module $PSScriptRoot\_Definitions.ps1
Import-Module $PSScriptRoot\GetCustomerLogsFolder.ps1
Import-Module $PSScriptRoot\ExtractGflPack.ps1
Import-Module $PSScriptRoot\GetCaseGflPack.ps1

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

        [string] $Destination = (Get-Location).Path,

        [int] $Skip = 0,

        [string] $CustomerIndexPath = $CustomerIndexDefaultPath
    )

    $destinationFullPath = [System.IO.Path]::GetFullPath($Destination)

    foreach ($gflPath in (Get-CaseGflPack $CustomerAccount $CaseNumber $CustomerIndexPath | select -Skip $Skip)) {
        Extract-GflPack $gflPath $destinationFullPath\$CustomerAccount\$CaseNumber\$([System.IO.Path]::GetFileNameWithoutExtension($gflPath.Name))
    }
}