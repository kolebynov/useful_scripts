#============================================================================
# Get sent documents from connector logs
#============================================================================
function Get-SentDocuments() {
    [cmdletbinding()]
    param (
        [string[]] $Path = @(),
        [parameter(ValueFromPipeline)]
        [string[]] $InputObject
    )
    begin {
        [string]$pattern = "(\d\d\d\d\.\d\d\.\d\d \d\d:\d\d:\d\d\.\d\d\d).+?URI:`"(.+?)`""
    }
    process {
        if ($null -eq $InputObject) {
            Select-String -Path $Path -Pattern $pattern |
                % { [pscustomobject]@{ Time = $_.Matches[0].Groups[1].Value; Uri = $_.Matches[0].Groups[2].Value }  }
        }
        else {
            Select-String -Pattern $pattern -InputObject $InputObject |
                % { [pscustomobject]@{ Time = $_.Matches[0].Groups[1].Value; Uri = $_.Matches[0].Groups[2].Value }  }
        }
    }
}