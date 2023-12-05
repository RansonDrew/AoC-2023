Part 1 was fairly straight forward. My approach was to find all the single digits in a line with a regex and take the first and the last match.

Part 2 seemed easy upfront, but the examples were supposed to clue me in that some of the text digits overlapped another digit. This meant that my simple regex was not seeing two matches that overlapped. After checking reddit, I wrote some code to replace the overlapp patterns with numeric equivalents. Then I did a replace on all other text digits with their numeric equivalents. After that, the code for part 1 provided the answer. I have updated the replace by storing the replace filters in an ordered dictionary and iterating through it rather than individual statements for each.

Part 1 Answer 56506
Part 2 Answer 56017
