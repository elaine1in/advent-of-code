#---------------------------------------------
# Author:       Elaine Lin
# Created Date: 2021-04-07
# References Used:
#---------------------------------------------

import os
from pathlib import Path

file_name = ((os.path.basename(__file__)).split('.')[0])
base_path = Path(__file__).parent.parent
file_path = (base_path / '../inputs/{0}.txt'.format(file_name)).resolve()

aoc_input = open(file_path).read()

answer_1 = 0
answer_2 = 0
length = len(aoc_input)
offset = length/2

for i, num in enumerate(aoc_input):
    halfway_index = int((i+offset)%length)
    if aoc_input[i]==aoc_input[i+1 if i!=len(aoc_input)-1 else 0]:
        answer_1 += int(num)
    if aoc_input[i]==aoc_input[halfway_index]:
        answer_2 += int(num)

#---------------------------------------------
# Part 1
#---------------------------------------------
print ('Part 1 Answer:', answer_1)

#---------------------------------------------
# Part 2
#---------------------------------------------
print ('Part 2 Answer:', answer_2)
