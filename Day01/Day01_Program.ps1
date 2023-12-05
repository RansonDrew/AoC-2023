function Sum-CalibrationValues {
    # Input is an object that takes the problem input as text with newline separators between lines.
    param (
        $CalibrationData
    )
    # Initialize the total
    $CalibrationTotal = 0
    foreach ($cd in $CalibrationData) {
        # Walk through the data and get all of the single digit matches in the line
        $mchs = $($cd | Select-String -Pattern '[0-9]' -AllMatches).Matches
        # Get the highest index by taking the object count and subtracting 1 (indices are 0 based)
        $topindex = ($mchs.count)-1
        $d1 = $mchs[0].Value
        $d2 = $mchs[$topindex].Value
        $num = [int]($d1 + $d2)
        $CalibrationTotal = $CalibrationTotal + $num
    }
    return $CalibrationTotal
}

function Repair-CalibrationData {
    param (
        $CalibrationData
    )
    # An ordered Dictionary of the possible repairs needed.
    $regvalues =  [ordered]@{
                        '(oneight)'     = '18'
                        '(threeight)'   = '38'
                        '(fiveight)'    = '58'
                        '(nineight)'    = '98'
                        '(eightwo)'     = '82'
                        '(eighthree)'   = '83'
                        '(twone)'       = '21'
                        '(sevenine)'    = '79'
                        '(one)'         = '1'
                        '(two)'         = '2'
                        '(three)'       = '3'
                        '(four)'        ='4'
                        '(five)'        = '5'
                        '(six)'         = '6'
                        '(seven)'       = '7'
                        '(eight)'       = '8'
                        '(nine)'        = '9'
                    }
    # Run through the repairs and apply them.
    foreach ($filt in $regvalues.GetEnumerator()) {
        $CalibrationData = $CalibrationData -replace $filt.Name , $filt.Value
    }
    return $CalibrationData
}

$inp = Get-Content ./Day01_input.txt

Write-Host "Part 1 Total is $(Sum-CalibrationValues -CalibrationData $inp)"

$inp = Repair-CalibrationData -CalibrationData $inp

Write-Host "Part 2 Total is $(Sum-CalibrationValues -CalibrationData $inp)"