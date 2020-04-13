#============================================================================
# Add full time to GF log lines
#============================================================================
function Add-TimeGfLogs() {
    [cmdletbinding()]
    param (
        [parameter(ValueFromPipeline)]
        [string[]] $Lines,
        [Nullable[System.DateTimeOffset]] $StartTime
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
            "$($currentTime.ToString("dd/MM/yyyy_HH", [cultureinfo]::InvariantCulture))_$_"
        }
        else {
            $_
        }
    }
    end {}
}