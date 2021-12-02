#---------------------------------------------
# Author:       Elaine Lin
# Created Date: 2021-12-01
# References Used:
#---------------------------------------------

import os
from pathlib import Path

file_name = ((os.path.basename(__file__)).split('.')[0])
base_path = Path(__file__).parent.parent
file_path = (base_path / '../inputs/{0}.txt'.format(file_name)).resolve()

aoc_input = [i for i in open(file_path).read().split('\n')]

def solve(aoc_input, part):
    pos = 0
    depth = 0
    aim = 0
    for command in aoc_input:
        dir, val = command.split()
        val = int(val)
        if dir=='forward':
            pos += val
            if part==2: depth += (aim*val)
        if dir in ['up', 'down']:
            if part==1: depth += val if dir=='down' else -val
            if part==2: aim += val if dir=='down' else -val
    return (pos*depth)

#---------------------------------------------
# Part 1
#---------------------------------------------
answer_1 = solve(aoc_input, 1)

print ('Part 1 Answer:', answer_1)

#---------------------------------------------
# Part 2
#---------------------------------------------
answer_2 = solve(aoc_input, 2)

print ('Part 2 Answer:', answer_2)
