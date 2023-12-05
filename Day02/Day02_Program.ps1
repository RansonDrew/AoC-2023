# It's silly, but I put the maximum values from part 1 in a hashtable to use in comparisons. 
# Three constants would have been just fine.
$maxvalues = @{
                    "red" = 12
                    "green" = 13
                    "blue" = 14
              }
# Read the input data file
$inp = Get-Content ./Day02_input.txt
# Initialize the part 1 and part 2 totals.
$Total = 0
$Total2 = 0
# Step through the input
foreach ($game in $inp) {
    # Get the game number value by parsing the line (being sure to cast it as an integer).
    [int]$gamenumber = $game.Split(':')[0].Split(' ')[1]
    # Initialize the current game maximum values
    $maxred = 0
    $maxgreen = 0
    $maxblue = 0
    # Parse the "tries" into a collection and step through it
    $tries = $game.Split(':')[1].Split(';')
    foreach ($trie in $tries) {
        # Parse the individual values into a collection and step through it
        $trievalues = $trie.Split(',')
        foreach ($v in $trievalues) {
            # Each value has a color and a number. Parse these values into variables.
            # It was critical to cast the numbers as integers because they are natively strings
            # and, "8" -lt "11" does not evaluate the way we want it to evaluate
            $color = $v.trim().Split(' ')[1]
            [int]$number = $v.trim().Split(' ')[0]
            # There is definitely a more efficient way to do this, but it's only three values.
            # So, we compare the values to current maximum for their color and if they are higher
            # we replace the current maximum with the value being compared
            if (($color -eq "red") -and ($number -gt $maxred)) {$maxred = $number}
            if (($color -eq "green") -and ($number -gt $maxgreen)) {$maxgreen = $number}
            if (($color -eq "blue") -and ($number -gt $maxblue)) {$maxblue = $number}                                                               
        }
    }
    # For part 1, we only add the game number to the total if all color values are less than or
    # equal to the predetermined maximums (game is "possible").
    if(($maxred -le $maxvalues['red']) -and ($maxgreen -le $maxvalues['green']) -and ($maxblue -le $maxvalues['blue'])){$Total = $Total + $gamenumber}
    $Total2 = $Total2 + ($maxred * $maxgreen * $maxblue)
}
Write-Host "Part 1 Total is $Total"
Write-Host "Part 2 Total is $Total2"