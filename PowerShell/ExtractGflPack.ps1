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

    $startTime = [datetime]::Now

    if (!(Test-Path $Path)) {
        throw "Gflpack file $Path does not exist"
    }

    Write-Verbose "Starting to extract gflpack $Path to $Destination"

    & $GfinFileViewerPath $Path $Destination -unpack | Write-Verbose

    $extractResult = Get-Content "$Destination\GFINFileViewer Return Code.txt" -Encoding Unicode

    if (!$extractResult.Equals("Gfunpack operation has completed.")) {
        throw $extractResult
    }

    Write-Verbose "Extracting of gflpack is finished"
}