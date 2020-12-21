#---------------------------------------------
# Author:       Elaine Lin
# Created Date: 2020-12-19
# References Used:
#   https://stackoverflow.com/questions/40416072/reading-file-using-relative-path-in-python-project
#   https://stackoverflow.com/questions/464864/how-to-get-all-possible-combinations-of-a-list-s-elements
#   https://stackoverflow.com/questions/3925614/how-do-you-read-a-file-into-a-list-in-python
#---------------------------------------------

from pathlib import Path
import itertools

base_path = Path(__file__).parent
file_path = (base_path / '../inputs/Day_1.txt').resolve()

aoc_day1_input = []

with open(file_path) as file:
    for line in file:
        aoc_day1_input.append(int(line))

#---------------------------------------------
# Part 1
#---------------------------------------------
entry1 = None
entry2 = None
answer = None
for i in (list(itertools.combinations(aoc_day1_input, 2))):
    if (i[0]+i[1])==2020:
        entry1 = i[0]
        entry2 = i[1]
        answer = (i[0]*i[1])
        break

print ('Part 1 Answer:', answer)
        
#---------------------------------------------
# Part 2
#---------------------------------------------
entry1 = None
entry2 = None
entry3 = None
answer = None
for i in (list(itertools.combinations(aoc_day1_input, 3))):
    if (i[0]+i[1]+i[2])==2020:
        entry1 = i[0]
        entry2 = i[1]
        entry3 = i[2]
        answer = (i[0]*i[1]*i[2])
        break

print ('Part 2 Answer:', answer)
        
