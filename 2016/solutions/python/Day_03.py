#---------------------------------------------
# Author:       Elaine Lin
# Created Date: 2021-03-09
# References Used: 
#   https://stackoverflow.com/questions/12974474/how-to-unzip-a-list-of-tuples-into-individual-lists
#   https://stackoverflow.com/questions/7558908/unpacking-a-list-tuple-of-pairs-into-two-lists-tuples
#---------------------------------------------

import os
from pathlib import Path

file_name = ((os.path.basename(__file__)).split('.')[0])
base_path = Path(__file__).parent.parent
file_path = (base_path / '../inputs/{0}.txt'.format(file_name)).resolve()

with open(file_path) as file:
    aoc_input = file.read()

aoc_input_1 = [[int(i) for i in line.strip().split()] for line in aoc_input.split('\n')]
aoc_input_2 = list(zip(*aoc_input_1))

#---------------------------------------------
# Part 1
#---------------------------------------------
answer1 = sum([1 for sides in aoc_input_1 if (sides[0]+sides[1]>sides[2]) and (sides[0]+sides[2]>sides[1]) and (sides[1]+sides[2]>sides[0])])

print ('Part 1 Answer:', answer1)

#---------------------------------------------
# Part 2
#---------------------------------------------
answer2 = sum([1 for col in aoc_input_2 for i in range(len(col)-2) if i%3==0 and (col[i]+col[i+1]>col[i+2]) and (col[i]+col[i+2]>col[i+1]) and (col[i+1]+col[i+2]>col[i])])

print ('Part 2 Answer:', answer2)
