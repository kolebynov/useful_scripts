#============================================================================
# Copy logs from customer index into specified folder
#============================================================================
function Copy-CustomerLogs() {
    [cmdletbinding()]
    param (
        [Parameter(Mandatory)]
        [string] $CustomerAccount,

        [Parameter(Mandatory)]
        [string] $CaseNumber,

        [Parameter(Mandatory)]
        [string] $Destination,

        [string] $CustomerIndexPath = "\\bym1-cs-log\Customers Index"
    )

    [string[]] $findPlaces = @(
        "$CustomerIndexPath\$CustomerAccount\$CaseNumber",
        "$CustomerIndexPath\IHS\$CaseNumber",
        "$CustomerIndexPath\IHS\$CustomerAccount\$CaseNumber"
    )

    $findPlace = [Linq.Enumerable]::FirstOrDefault(
        $findPlaces,
        [Func[string, bool]] {
            param($testPlace)
            Write-Verbose "Testing a folder $testPlace"
            Test-Path $testPlace -Verbose:$VerbosePreference -Debug:$DebugPreference
        })

    Write-Verbose "Found a folder with a case: $findPlace"

    if ($findPlace -ne $null) {
        Copy-Item -Path $findPlace -Destination "$Destination\$CustomerAccount" -Force -Recurse -Verbose:$VerbosePreference -Debug:$DebugPreference
    }
    else {
        throw "Couldn't find a case folder. [Customer: $CustomerAccount][Case: $CaseNumber]";
    }
}