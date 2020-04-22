Import-Module $PSScriptRoot\_Definitions.ps1

#============================================================================
# Extract memory usage log from docgen logs
#============================================================================
function Get-MemoryUsageLog() {
    [cmdletbinding()]
    param (
        [string[]] $Path = @(),
        [parameter(ValueFromPipeline)]
        [string[]] $InputObject
    )
    begin {
        [string]$pattern = "(^@@)|(\`$ OS:)|(\`$ WS:)"
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