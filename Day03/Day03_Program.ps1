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

function Get-GearRatioSumByRow {
    param (
        [int]$CurrentRowIndex,
        $SearchMatrix
    )
    $gearratiosum = 0
    # In every case we will search the current row for possible gears and digits
    $possiblegears = $($SearchMatrix[$CurrentRowIndex] | Select-String -Pattern '\*' -AllMatches).Matches
    #Write-Host "$($possiblegears.count) possible gears found"
    $currentrow = $($SearchMatrix[$CurrentRowIndex] | Select-String '\d+' -AllMatches).Matches
    # If we are on the first row of the search matrix there is no look back
    if ($CurrentRowIndex -eq 0) {
        $beforerow = $null
    } else {
        $beforerow = $($SearchMatrix[$CurrentRowIndex - 1] | Select-String '\d+' -AllMatches).Matches
    }
    # If we are on the last row of the search matrix there is no look ahead
    if ($CurrentRowIndex -eq ($SearchMatrix.Count -1)) {
        $afterrow = $null
    } else {
        $afterrow = $($SearchMatrix[$CurrentRowIndex + 1] | Select-String '\d+' -AllMatches).Matches
    }
    # Since all variables now have 'something' in them, we should be able to appl the same logic
    # to every row. 

    # Now we loop through the 'possibles'
    foreach ($p in $possiblegears) {
        # Initialize a part array to which we will add an item each time we find a match adjacent to 
        # a possible gear
        $partlist = @()
        $partlist += $beforerow | Where-Object -FilterScript {(($_.Index -le ($p.Index + $p.Length)) -and (($_.Index + $_.Length - 1) -ge ($p.Index -1)))} | Select-Object -ExpandProperty Value
        $partlist += $currentrow | Where-Object -FilterScript {(($_.Index + $_.Length - 1) -eq $p.Index -1) -or ($_.Index -eq ($p.Index + $p.Length))} | Select-Object -ExpandProperty Value
        $partlist += $afterrow | Where-Object -FilterScript {(($_.Index -le ($p.Index + $p.Length)) -and (($_.Index + $_.Length - 1) -ge ($p.Index -1)))} | Select-Object -ExpandProperty Value 
        # If the partlist count is exactly 2, multiply them together and add them to gearratiosum
        if ($partlist.count -eq 2) {$gearratiosum = $gearratiosum + ([int]$partlist[0] * [int]$partlist[1])}
    }
    return $gearratiosum
}

# Read the input data
$inp = Get-Content ./Day03_input.txt
# Initialize the total value
$Total = 0
$GearTotal = 0
# Get the maximum index by looking at the count property of $inp and subtracting 1
$maxindex = $inp.Count - 1

# Loop through rows 0-139 (or whatever the maximum - 1 is)
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
    $GearTotal = $GearTotal + (Get-GearRatioSumByRow -CurrentRowIndex $r -SearchMatrix $inp)
}

Write-Host "Part 1 Answer is $Total"
Write-Host "Part 2 Answer is $GearTotal"