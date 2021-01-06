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