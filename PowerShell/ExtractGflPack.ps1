Import-Module $PSScriptRoot\_Definitions.ps1

#============================================================================
# Extract gflpack to destination folder
#============================================================================
function Extract-GflPack() {
    [cmdletbinding()]
    param (
        [Parameter(Mandatory)]
        [string] $Path,

        [Parameter(Mandatory)]
        [string] $Destination,

        [string] $GfinFileViewerPath = $GfinFileViewerDefaultPath
    )

    if (!(Test-Path $Path)) {
        throw "Gflpack file $Path does not exist"
    }

    Write-Verbose "Starting to extract gflpack $Path to $Destination"

    & $GfinFileViewerPath $Path $Destination -unpack

    if (Test-Path "$Destination\GFINFileViewer Return Code.txt") {
        throw (Get-Content "$Destination\GFINFileViewer Return Code.txt" -Encoding Unicode)
    }

    Write-Verbose "Extracting of gflpack is finished"
}