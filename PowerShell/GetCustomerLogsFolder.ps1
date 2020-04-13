Import-Module $PSScriptRoot\_Definitions.ps1

#============================================================================
# Find customer logs folder by customer account and case number.
#============================================================================
function Get-CustomerLogsFolder() {
    [cmdletbinding()]
    param (
        [Parameter(Mandatory)]
        [string] $CustomerAccount,

        [Parameter(Mandatory)]
        [string] $CaseNumber,

        [string] $CustomerIndexPath = $CustomerIndexDefaultPath
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
            Test-Path $testPlace
        })

    if ($findPlace -eq $null) {
        throw "Folder with a case not found. [Customer: $CustomerAccount][Case: $CaseNumber]"
    }

    Write-Verbose "Found a folder with a case: $findPlace"

    return $findPlace
}