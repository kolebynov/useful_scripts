#============================================================================
# Skip while the condition is true
#============================================================================
function Skip-While() {
    param ( [scriptblock]$pred = $(throw "Need a predicate") )
    begin {
        $skip = $true
    }
    process {
        if ( $skip ) {
            $skip = & $pred $_
        }

        if ( -not $skip ) {
            $_
        }
    }
    end {}
}