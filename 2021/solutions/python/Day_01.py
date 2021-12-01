#---------------------------------------------
# Author:       Elaine Lin
# Created Date: 2021-11-30
# References Used:
#---------------------------------------------

import os
from pathlib import Path

file_name = ((os.path.basename(__file__)).split('.')[0])
base_path = Path(__file__).parent.parent
file_path = (base_path / '../inputs/{0}.txt'.format(file_name)).resolve()

aoc_input = [int(i) for i in open(file_path).read().split('\n')]

#---------------------------------------------
# Part 1
#---------------------------------------------
answer_1 = sum([1 for i in range(len(aoc_input)-1) if aoc_input[i]<aoc_input[i+1]])

print ('Part 1 Answer:', answer_1)

#---------------------------------------------
# Part 2
#---------------------------------------------
answer_2 = sum([1 for i in range(len(aoc_input)) if sum(aoc_input[i:i+3])<sum(aoc_input[i+1:i+4]) and len(aoc_input[i:i+3])==3 and len(aoc_input[i+1:i+4])==3])

print ('Part 2 Answer:', answer_2)
