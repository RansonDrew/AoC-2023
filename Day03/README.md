Blehhhhh!!!! I had such a time with all the logcal conditions involved in searching around a number in a 2D array. I kept getting the wrong number over and over. Eventually I went through the data and results and found that I didn't have logic that account for a match at the end of a row. When I tried to account for that, I didn't catch the case where the end of the row entry was also a match. I functionalized the search after which it still didn't work. Eventually I found that I had omitted one of the comparison operators in one of my if statements.

The approach I used in part 2 could be cleaned up to apply to part 1 as well. It would make the script better. Maybe I will come back later and fix it up. 

I want to look at the regex - '(?!\.|[0-9]).'  It finds all the symbols and ignores '.' and digits

Okay, final version. Instead of looking at 2D arrays cells around matches, I just compared match locations with a secondary set of match locations. If the span of the matches overlaps, they are adjacent. If a match (or matches) is adjacent, add it to an array. When doing part numbers, the array only needs to be more than zero. If it is, add the value of the reference item (digit group) to the total. When looking at gear ratios, the array has to have exactly two members. If it does, multiply the two members together and add that value to the total.

There is likely a more efficient way to do this puzzle, but overall I like this approach.

Part 1 Answer is 554003
Part 2 Answer is 87263515