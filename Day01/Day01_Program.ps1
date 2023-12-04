function Sum-CalibrationValues {
    param (
        $CalibrationData
    )
    $CalibrationTotal = 0
    foreach ($cd in $CalibrationData) {
        $mchs = $($cd | Select-String -Pattern '[0-9]' -AllMatches).Matches
        $topindex = $mchs | Measure-Object | Select-Object -ExpandProperty Count
        $d1 = $mchs[0].Value
        $d2 = $mchs[$topindex-1].Value
        $num = [int]($d1 + $d2)
        $CalibrationTotal = $CalibrationTotal + $num
    }
    return $CalibrationTotal
}

function Repair-CalibrationData {
    param (
        $CalibrationData
    )
    $CalibrationData = $CalibrationData -replace '(oneight)','18'
    $CalibrationData = $CalibrationData -replace '(threeight)','38'
    $CalibrationData = $CalibrationData -replace '(fiveight)','58'
    $CalibrationData = $CalibrationData -replace '(nineight)','98'
    $CalibrationData = $CalibrationData -replace '(eightwo)','82'
    $CalibrationData = $CalibrationData -replace '(eighthree)','83'
    $CalibrationData = $CalibrationData -replace '(twone)','21'
    $CalibrationData = $CalibrationData -replace '(sevenine)','79'
    $CalibrationData = $CalibrationData -replace '(one)','1'
    $CalibrationData = $CalibrationData -replace '(two)','2'
    $CalibrationData = $CalibrationData -replace '(three)','3'
    $CalibrationData = $CalibrationData -replace '(four)','4'
    $CalibrationData = $CalibrationData -replace '(five)','5'
    $CalibrationData = $CalibrationData -replace '(six)','6'
    $CalibrationData = $CalibrationData -replace '(seven)','7'
    $CalibrationData = $CalibrationData -replace '(eight)','8'
    $CalibrationData = $CalibrationData -replace '(nine)','9'
    return $CalibrationData
}

$inp = Get-Content ./Day01_input.txt

Write-Host "Part 1 Total is $(Sum-CalibrationValues -CalibrationData $inp)"

$inp = Repair-CalibrationData -CalibrationData $inp

Write-Host "Part 2 Total is $(Sum-CalibrationValues -CalibrationData $inp)"