Import-Module $PSScriptRoot\AddTimeGfLogs.ps1

#============================================================================
# Extract all SharePoint logs or only logs from specified SharePoint task from DocGen logs
#============================================================================
function Extract-Sp-Logs() {
    [cmdletbinding()]
    param (
        [parameter(Mandatory=$true)]
        [string[]] $Path,
        [string] $TaskId
    )
    [string]$pattern = "(SPG\.\w)|(^@@)"
    if ($TaskId -ne $null) {
        $pattern = "$pattern|(:$TaskId\])"
    }

    sls -Path $Path -Pattern $pattern | select -ExpandProperty Line | Add-Time-Gf-Logs
}