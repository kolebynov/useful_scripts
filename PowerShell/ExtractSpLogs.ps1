#============================================================================
# Extract all SharePoint logs or only logs from specified SharePoint task from DocGen logs
#============================================================================
function Get-SpLogs() {
    [cmdletbinding()]
    param (
        [string[]] $Path = @(),
        [string] $TaskId,
        [parameter(ValueFromPipeline)]
        [string[]] $InputObject
    )
    begin {
        [string]$pattern = "(\[SPG\.\w)|(^@@)"
        if (![string]::IsNullOrEmpty($TaskId)) {
            $pattern = "(\[SPG\.\w\])|(^@@)|(:$TaskId\])"
        }
    }
    process {
        if ($null -eq $InputObject) {
            $selectRes = Select-String -Path $Path -Pattern $pattern
        }
        else {
            $selectRes = Select-String -Pattern $pattern -InputObject $InputObject
        }

        $selectRes | Select-Object -ExpandProperty Line
    }
}