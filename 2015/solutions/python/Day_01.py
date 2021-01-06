#---------------------------------------------
# Author:       Elaine Lin
# Created Date: 2021-01-05
# References Used:
#---------------------------------------------

from pathlib import Path

base_path = Path(__file__).parent.parent
file_path = (base_path / '../inputs/Day_01.txt').resolve()

aoc_input = []

with open(file_path) as file:
    aoc_input = file.read()

#---------------------------------------------
# Part 1
#---------------------------------------------
answer = (aoc_input.count('(')) - (aoc_input.count(')'))

print ('Part 1 Answer:', answer)

#---------------------------------------------
# Part 2
#---------------------------------------------
floor = 0
position = None
for i in range(len(aoc_input)):
    value = 1 if aoc_input[i]=='(' else -1
    floor += value
    if floor == -1:
        position = i+1
        break
        
print ('Part 2 Answer:', position)
