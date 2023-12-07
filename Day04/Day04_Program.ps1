$inp = Get-Content ./Day04_input.txt
$pointtotal = 0
$cards = $inp | Select-Object @{n="CardNumber";e={[int]$_.Split(':')[0].Split(' ')[1]}},
                              @{n="WinningNums";e={$_.Split(':')[1].Split(' | ')[0].Trim().Replace('  ',' ').Split(' ')}},
                              @{n="MyNums";e={$_.Split(':')[1].Split(' | ')[1].Trim().Replace('  ',' ').Split(' ')}},
                              @{n="Instance";e={1}}

$maxcardindex = $cards.count - 1
foreach ($c in (0..($maxcardindex - 1))){
    $wins = $(Compare-Object -ReferenceObject $cards[$c].WinningNums -DifferenceObject $cards[$c].MyNums -ExcludeDifferent -IncludeEqual).Count
    if (($c + $wins) -gt $maxcardindex) {$upperbound = $maxcardindex} else {$upperbound = $c + $wins}
    for ($i = $c + 1; $i -le $upperbound; $i++) {
        $cards[$i].Instance = $cards[$i].Instance + $cards[$c].Instance
    }
    if ($wins -gt 0) {$pointtotal = $pointtotal + [Math]::Pow(2,($wins - 1))}
}


Write-Host "Part 1 Answer is $pointtotal"
Write-Host "Part 2 Answer is $($cards | Measure-Object -Property Instance -Sum | Select-Object -ExpandProperty Sum)"