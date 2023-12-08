function Get-SumByRow {
    param (
        [int]$CurrentRowIndex,
        $SearchMatrix,
        [ValidateSet('part','gear')]$SumType
    )
    $thesum = 0
    # Is it a part sum by row or gear ratio sum by row
    switch ($SumType) {
        'part' {
            $f1 = '\d+' # regex for digit groups
            $f2 = '(?!\.|[0-9]).' # regex for anything that is not a '.' or a single digit
        }
        'gear' {
            $f1 = '\*' # regex for a single '*'
            $f2 = '\d+' # regex for digit groups
        }
    }
    # In every case we will search the current row for possible matches
    $possibles = $($SearchMatrix[$CurrentRowIndex] | Select-String $f1 -AllMatches).Matches
    $currentrow = $($SearchMatrix[$CurrentRowIndex] | Select-String $f2 -AllMatches).Matches
    # If we are on the first row of the search matrix there is no look back
    if ($CurrentRowIndex -eq 0) {
        $beforerow = $null
    } else {
        $beforerow = $($SearchMatrix[$CurrentRowIndex - 1] | Select-String $f2 -AllMatches).Matches
    }
    # If we are on the last row of the search matrix there is no look ahead
    if ($CurrentRowIndex -eq ($SearchMatrix.Count -1)) {
        $afterrow = $null
    } else {
        $afterrow = $($SearchMatrix[$CurrentRowIndex + 1] | Select-String $f2 -AllMatches).Matches
    }
    # Since all variables now have 'something' in them, we should be able to apply the same logic
    # to every row. 
    # Now we loop through the 'possibles'
    foreach ($p in $possibles) {
        # Initialize a variable to hold the matches from  the row above, the current row, and the row below
        $thelist = @()
        $thelist += $beforerow | Where-Object -FilterScript {(($_.Index -le ($p.Index + $p.Length)) -and (($_.Index + $_.Length - 1) -ge ($p.Index -1)))} | Select-Object -ExpandProperty Value
        $thelist += $currentrow | Where-Object -FilterScript {(($_.Index + $_.Length - 1) -eq $p.Index -1) -or ($_.Index -eq ($p.Index + $p.Length))} | Select-Object -ExpandProperty Value
        $thelist += $afterrow | Where-Object -FilterScript {(($_.Index -le ($p.Index + $p.Length)) -and (($_.Index + $_.Length - 1) -ge ($p.Index -1)))} | Select-Object -ExpandProperty Value 

        switch ($SumType) {
            # if there is at least one adjacent symbol, add the value of the digit group to the total
            'part' {if ($thelist.count -gt 0) {$thesum = $thesum + [int]$p.Value}} 
            # if there are exactly two digit groups adjacent to a gear, multiply their values and add them to the total
            'gear' {if ($thelist.count -eq 2) {$thesum = $thesum + ([int]$thelist[0] * [int]$thelist[1])}}
        } 
    }
    return $thesum
}

# Start of Main Program
$inp = Get-Content ./Day03_input.txt # Read the input data
$PartTotal = 0 # Initialize the part 1 total value
$GearTotal = 0 # Initialize the part 2 total value

# Loop through all rows
foreach ($r in $(0..($inp.Count - 1))) {
    $PartTotal = $PartTotal + (Get-SumByRow -CurrentRowIndex $r -SearchMatrix $inp -SumType "part")
    $GearTotal = $GearTotal + (Get-SumByRow -CurrentRowIndex $r -SearchMatrix $inp -SumType "gear")
}

Write-Host "Part 1 Answer is $PartTotal"
Write-Host "Part 2 Answer is $GearTotal"