$inp = Get-Content -Raw -Path ./Day05_input.txt # The -Raw parameter is needed to be able to split by "`n`n"

$fields = $inp.Split("`n`n")

$seeds = $fields[0].Split(":")[1].Trim().Split(" ")
$seedsoilmap = $fields[1].Split("`n") | 
               Select-Object -Skip 1 -Property @{n="DstRngStart";e={[int64]$_.Split(" ")[0]}},
                                               @{n="SrcRngStart";e={[int64]$_.Split(" ")[1]}},
                                               @{n="RngLength"  ;e={[int64]$_.Split(" ")[2]}}
$soilfertmap = $fields[2].Split("`n") | 
               Select-Object -Skip 1 -Property @{n="DstRngStart";e={[Int64]$_.Split(" ")[0]}},
                                               @{n="SrcRngStart";e={[Int64]$_.Split(" ")[1]}},
                                               @{n="RngLength"  ;e={[Int64]$_.Split(" ")[2]}}
$fertwatrmap = $fields[3].Split("`n") | 
               Select-Object -Skip 1 -Property @{n="DstRngStart";e={[Int64]$_.Split(" ")[0]}},
                                               @{n="SrcRngStart";e={[Int64]$_.Split(" ")[1]}},
                                               @{n="RngLength"  ;e={[Int64]$_.Split(" ")[2]}}
$watrlitemap = $fields[4].Split("`n") | 
               Select-Object -Skip 1 -Property @{n="DstRngStart";e={[Int64]$_.Split(" ")[0]}},
                                               @{n="SrcRngStart";e={[Int64]$_.Split(" ")[1]}},
                                               @{n="RngLength"  ;e={[Int64]$_.Split(" ")[2]}}
$litetempmap = $fields[5].Split("`n") | 
               Select-Object -Skip 1 -Property @{n="DstRngStart";e={[Int64]$_.Split(" ")[0]}},
                                               @{n="SrcRngStart";e={[Int64]$_.Split(" ")[1]}},
                                               @{n="RngLength"  ;e={[Int64]$_.Split(" ")[2]}}
$temphumimap = $fields[6].Split("`n") | 
               Select-Object -Skip 1 -Property @{n="DstRngStart";e={[Int64]$_.Split(" ")[0]}},
                                               @{n="SrcRngStart";e={[Int64]$_.Split(" ")[1]}},
                                               @{n="RngLength"  ;e={[Int64]$_.Split(" ")[2]}}
$humilocamap = $fields[7].Split("`n") | 
               Select-Object -Skip 1 -Property @{n="DstRngStart";e={[Int64]$_.Split(" ")[0]}},
                                               @{n="SrcRngStart";e={[Int64]$_.Split(" ")[1]}},
                                               @{n="RngLength"  ;e={[Int64]$_.Split(" ")[2]}}

# If a seed number matches a mapping, it gets transformed by the difference between the 
# destination range start number and the source range start number
# Let's do an array of locations and then we can sort them lowest to highest
$closest = @()

foreach ($s in $seeds) {
    $seedval = [int128]$s
    $seedsoiltest = $seedsoilmap | Where-Object -FilterScript {($_.SrcRngStart -le $seedval) -and (($_.SrcRngStart + $_.RngLength) -gt $seedval)}
    if ($seedsoiltest.Count -gt 0) {$seedval = $seedval + ($seedsoiltest.DstRngStart - $seedsoiltest.SrcRngStart)}
    $soilferttest = $soilfertmap | Where-Object -FilterScript {($_.SrcRngStart -le $seedval) -and (($_.SrcRngStart + $_.RngLength) -gt $seedval)}
    if ($soilferttest.Count -gt 0) {$seedval = $seedval + ($soilferttest.DstRngStart - $soilferttest.SrcRngStart)}
    $fertwatrtest = $fertwatrmap | Where-Object -FilterScript {($_.SrcRngStart -le $seedval) -and (($_.SrcRngStart + $_.RngLength) -gt $seedval)}
    if ($fertwatrtest.Count -gt 0) {$seedval = $seedval + ($fertwatrtest.DstRngStart - $fertwatrtest.SrcRngStart)}
    $watrlitetest = $watrlitemap | Where-Object -FilterScript {($_.SrcRngStart -le $seedval) -and (($_.SrcRngStart + $_.RngLength) -gt $seedval)}
    if ($watrlitetest.Count -gt 0) {$seedval = $seedval + ($watrlitetest.DstRngStart - $watrlitetest.SrcRngStart)}
    $litetemptest = $litetempmap | Where-Object -FilterScript {($_.SrcRngStart -le $seedval) -and (($_.SrcRngStart + $_.RngLength) -gt $seedval)}
    if ($litetemptest.Count -gt 0) {$seedval = $seedval + ($litetemptest.DstRngStart - $litetemptest.SrcRngStart)}
    $temphumitest = $temphumimap | Where-Object -FilterScript {($_.SrcRngStart -le $seedval) -and (($_.SrcRngStart + $_.RngLength) -gt $seedval)}
    if ($temphumitest.Count -gt 0) {$seedval = $seedval + ($temphumitest.DstRngStart - $temphumitest.SrcRngStart)}
    $humilocatest = $humilocamap | Where-Object -FilterScript {($_.SrcRngStart -le $seedval) -and (($_.SrcRngStart + $_.RngLength) -gt $seedval)}
    if ($humilocatest.Count -gt 0) {$seedval = $seedval + ($humilocatest.DstRngStart - $humilocatest.SrcRngStart)}
    $closest += $seedval
}
$closest = $closest | Sort-Object
Write-Host "Part 1 Answer is $($closest[0])"
# part 2

$newseeds = for ($i=0; $i -lt $seeds.count; $i += 2) {(([int64]$seeds[$i])..([int64]$seeds[$i] + [int64]$seeds[$i+1] - 1))}
$closest = @()

foreach ($s in $newseeds) {
    $seedval = [int128]$s
    $seedsoiltest = $seedsoilmap | Where-Object -FilterScript {($_.SrcRngStart -le $seedval) -and (($_.SrcRngStart + $_.RngLength) -gt $seedval)}
    if ($seedsoiltest.Count -gt 0) {$seedval = $seedval + ($seedsoiltest.DstRngStart - $seedsoiltest.SrcRngStart)}
    $soilferttest = $soilfertmap | Where-Object -FilterScript {($_.SrcRngStart -le $seedval) -and (($_.SrcRngStart + $_.RngLength) -gt $seedval)}
    if ($soilferttest.Count -gt 0) {$seedval = $seedval + ($soilferttest.DstRngStart - $soilferttest.SrcRngStart)}
    $fertwatrtest = $fertwatrmap | Where-Object -FilterScript {($_.SrcRngStart -le $seedval) -and (($_.SrcRngStart + $_.RngLength) -gt $seedval)}
    if ($fertwatrtest.Count -gt 0) {$seedval = $seedval + ($fertwatrtest.DstRngStart - $fertwatrtest.SrcRngStart)}
    $watrlitetest = $watrlitemap | Where-Object -FilterScript {($_.SrcRngStart -le $seedval) -and (($_.SrcRngStart + $_.RngLength) -gt $seedval)}
    if ($watrlitetest.Count -gt 0) {$seedval = $seedval + ($watrlitetest.DstRngStart - $watrlitetest.SrcRngStart)}
    $litetemptest = $litetempmap | Where-Object -FilterScript {($_.SrcRngStart -le $seedval) -and (($_.SrcRngStart + $_.RngLength) -gt $seedval)}
    if ($litetemptest.Count -gt 0) {$seedval = $seedval + ($litetemptest.DstRngStart - $litetemptest.SrcRngStart)}
    $temphumitest = $temphumimap | Where-Object -FilterScript {($_.SrcRngStart -le $seedval) -and (($_.SrcRngStart + $_.RngLength) -gt $seedval)}
    if ($temphumitest.Count -gt 0) {$seedval = $seedval + ($temphumitest.DstRngStart - $temphumitest.SrcRngStart)}
    $humilocatest = $humilocamap | Where-Object -FilterScript {($_.SrcRngStart -le $seedval) -and (($_.SrcRngStart + $_.RngLength) -gt $seedval)}
    if ($humilocatest.Count -gt 0) {$seedval = $seedval + ($humilocatest.DstRngStart - $humilocatest.SrcRngStart)}
    $closest += $seedval
}
$closest = $closest | Sort-Object
Write-Host "Part 2 Answer is $($closest[0])"