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
            Select-String -Path $Path -Pattern $pattern | Select-Object -ExpandProperty Line
        }
        else {
            Select-String -Pattern $pattern -InputObject $InputObject | Select-Object -ExpandProperty Line
        }
    }
}