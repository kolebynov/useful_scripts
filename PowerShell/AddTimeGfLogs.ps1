#============================================================================
# Add full time to GF log lines
#============================================================================
function Add-TimeGfLogs() {
    [cmdletbinding()]
    param (
        [parameter(ValueFromPipeline)]
        [string[]] $Lines,
        [Nullable[System.DateTimeOffset]] $StartTime,
        [string] $Format = "yyyy.MM.dd HH:mm:ss.fff"
    )
    begin {
        [Nullable[System.DateTimeOffset]] $currentTime = $StartTime
        [regex] $logLineRegex = [regex]::new("^\d\d\d\d\.\d\d\d", [System.Text.RegularExpressions.RegexOptions]::Compiled)
    }
    process {
        [string]$currentLine = $_

        if ($currentLine.StartsWith("@@")) {
            $timeParts = $currentLine.Remove(0, 2).Split('_')
            $currentTime = [System.DateTimeOffset]::Parse($timeParts[0])
            $currentTime = $currentTime.AddHours([double]::Parse($timeParts[1]))
        }

        if ($null -ne $currentTime -and $logLineRegex.IsMatch($currentLine)) {
            $lineMinutes = $currentLine.Substring(0, 2)
            $lineSeconds = $currentLine.Substring(2, 6)
            $lineTime = $currentTime.Add([timespan]::Parse("00:$lineMinutes`:$lineSeconds"))
            "$($lineTime.ToString($Format)) $($currentLine.Remove(0, 8))"
        }
        else {
            $_
        }
    }
    end {}
}