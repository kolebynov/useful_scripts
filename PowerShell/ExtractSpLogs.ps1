#============================================================================
# Extract all SharePoint logs or only logs from specified SharePoint task from DocGen logs
#============================================================================
function Extract-Sp-Logs() {
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
            write "task id not null $TaskId"
            $pattern = "(\[SPG\.\w\])|(^@@)|(:$TaskId\])"
        }
    }
    process {
        if ($InputObject -eq $null) {
            $selectRes = sls -Path $Path -Pattern $pattern
        }
        else {
            $selectRes = sls -Pattern $pattern -InputObject $InputObject
        }

        $selectRes | select -ExpandProperty Line
    }
}