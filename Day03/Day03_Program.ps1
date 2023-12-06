function Search-AdjacentCharacter {
    param (
        [int]$CurrentRowIndex,
        $SearchMatrix,
        [System.Text.RegularExpressions.Match]$MatchObject
    )
    $foundadjacent = $false
    $SearchMatrixRowEndIndex = $SearchMatrix[$CurrentRowIndex].Length - 1
    $StartIndex = $MatchObject.Index
    $EndIndex = $StartIndex + $MatchObject.Length - 1
    $SearchStartIndex = $StartIndex -1
    $EndSearchIndex = $EndIndex + 1
    if ($StartIndex -eq 0) {
        $SearchStartIndex = $SearchStartIndex +1
        if (($SearchMatrix[$CurrentRowIndex][$EndSearchIndex] -ne '.')) { $foundadjacent = $true }
    } elseif ($EndIndex -eq $SearchMatrixRowEndIndex) {
        $EndSearchIndex = $EndSearchIndex - 1
        if (($SearchMatrix[$CurrentRowIndex][$SearchStartIndex] -ne '.')) { $foundadjacent = $true }
    } else {
        if (($SearchMatrix[$CurrentRowIndex][$SearchStartIndex] -ne '.') -or ($SearchMatrix[$CurrentRowIndex][$EndSearchIndex] -ne '.')) { $foundadjacent = $true }
    }
    if($CurrentRowIndex -eq 0) {   
        foreach ($i in ($SearchStartIndex..$EndSearchIndex)) {
            if (($SearchMatrix[$CurrentRowIndex + 1][$i] -ne '.')) { $foundadjacent = $true }
        }
    } elseif ($CurrentRowIndex -eq ($SearchMatrix.Count -1)) {
        foreach ($i in ($SearchStartIndex..$EndSearchIndex)) {
            if (($SearchMatrix[$CurrentRowIndex - 1][$i] -ne '.')) { $foundadjacent = $true }
        }
    } else {
        foreach ($i in ($SearchStartIndex..$EndSearchIndex)) {
            if (($SearchMatrix[$CurrentRowIndex + 1][$i] -ne '.') -or ($SearchMatrix[$CurrentRowIndex - 1][$i] -ne '.')) { $foundadjacent = $true }
        }
    }
    return $foundadjacent
}

# Read the input data
$inp = Get-Content ./Day03_input.txt
# Initialize the total value
$Total = 0
# Get the maximum index by looking at the count property of $inp and subtracting 1
$maxindex = $inp.Count - 1

# Loop through rows 2-139 (or whatever the maximum - 1 is)
foreach ($r in $(0..($maxindex))) {
    $partnums = @()
    $nonpartnums = @()
    $rowtotal = 0
    $rownums = $($inp[$r] | Select-String -Pattern '\d+' -AllMatches).Matches
    foreach ($num in $rownums) {
        $ispartnum = Search-AdjacentCharacter -CurrentRowIndex $r -SearchMatrix $inp -MatchObject $num        
        if ($ispartnum) {
            $Total = $Total + [int]$num.Value
            $rowtotal = $rowtotal + [int]$num.Value
        }
        if ($ispartnum) {$partnums += $num.Value} else {$nonpartnums += $num.Value}
    }
}

Write-Host "Part 1 Answer is $Total"