#---------------------------------------------
# Author:       Elaine Lin
# Created Date: 2021-04-15
# References Used:
#   https://www.reddit.com/r/adventofcode/comments/5h52ro/2016_day_8_solutions/
#   https://www.programiz.com/python-programming/matrix
#   https://www.w3resource.com/numpy/manipulation/roll.php
#   https://numpy.org/doc/stable/reference/generated/numpy.roll.html
#   https://note.nkmk.me/en/python-numpy-count/
#---------------------------------------------

import numpy as np
import os
from pathlib import Path

file_name = ((os.path.basename(__file__)).split('.')[0])
base_path = Path(__file__).parent.parent
file_path = (base_path / '../inputs/{0}.txt'.format(file_name)).resolve()

aoc_input = open(file_path).read().split('\n')

#---------------------------------------------
# Test Scenario
#---------------------------------------------
# rows = 3
# columns = 7

# aoc_input = ['rect 3x2'
#             ,'rotate column x=1 by 1'
#             ,'rotate row y=0 by 4'
#             ,'rotate column x=1 by 1']

rows = 6
columns = 50

grid = np.array([['.' for j in range(columns)] for i in range(rows)])

for i, instruction in enumerate(aoc_input):
    if 'rect ' in instruction:
        w, h = instruction.split(' ')[1].split('x')
        w = int(w)
        h = int(h)
        grid[:h, :w] = '#'
    elif 'rotate ' in instruction:
        instruction = instruction.replace('rotate ', '')
        ix_space = instruction.index(' ')
        rc = instruction[:ix_space]
        value = instruction[ix_space+1:][2:]
        a, b = value.split(' by ')
        a = int(a)
        b = int(b)
        # print ('rc:', rc, 'a:', a, 'b:', b)
        if rc=='column':
            grid[:, a] = np.roll(grid[:, a], b, 0)
        if rc=='row':
            grid[a, :] = np.roll(grid[a, :], b) # don't need to specify axis (optional third parameter) here as I'm already splicing it by the row itself

#---------------------------------------------
# Part 1
#---------------------------------------------
answer_1 = np.count_nonzero(grid == '#')

print ('Part 1 Answer:', answer_1)

#---------------------------------------------
# Part 2
#---------------------------------------------
lw = 5
lh = 6

print ('Part 2 Answer:')
for i in range(0, columns, lw):
    print (grid[:, i:i+lw], '\n') # EFEYKFRFIJ
