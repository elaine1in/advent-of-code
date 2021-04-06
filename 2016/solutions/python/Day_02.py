#---------------------------------------------
# Author:       Elaine Lin
# Created Date: 2021-04-05
# References Used:
#---------------------------------------------

import os
from pathlib import Path

file_name = ((os.path.basename(__file__)).split('.')[0])
base_path = Path(__file__).parent.parent
file_path = (base_path / '../inputs/{0}.txt'.format(file_name)).resolve()

aoc_input = None

with open(file_path) as file:
    aoc_input = file.read().split('\n')

#---------------------------------------------
# Test Scenario
#---------------------------------------------
# aoc_input = ['ULL'
#             ,'RRDDD'
#             ,'LURDL'
#             ,'UUUUD']

#---------------------------------------------
#---------------------------------------------
def reindex(i, l):
    if i<0:
        return (0)
    elif i>l:
        return (l)
    else:
        return (i)

def check_index_part_2(ri, ci, command):
    new_ri = ri + (1 if command=='D' else 0) + (-1 if command=='U' else 0)
    new_ci = ci + (1 if command=='R' else 0) + (-1 if command=='L' else 0)

    new_ri = reindex(new_ri, l)
    new_ci = reindex(new_ci, l)
    
    return (new_ri, new_ci) if keypad[new_ri][new_ci] is not None else (ri, ci)

#---------------------------------------------
# Part 1
#---------------------------------------------
keypad = [[1, 2, 3]
        ,[4, 5, 6]
        ,[7, 8, 9]]

l = len(keypad)-1
answer_1 = ''

for i, line in enumerate(aoc_input):
    digit = 5 if i==0 else int(answer_1[-1])
    k1, k2 = [(ip1, ip2) for ip1, p1 in enumerate(keypad) for ip2, p2 in enumerate(p1) if p2==digit][0]

    for i2, command in enumerate(line):
        k1 += (1 if command=='D' else 0) + (-1 if command=='U' else 0)
        k2 += (1 if command=='R' else 0) + (-1 if command=='L' else 0)

        k1 = reindex(k1, l)
        k2 = reindex(k2, l)

    answer_1 += str(keypad[k1][k2])

print ('Part 1 Answer:', answer_1)

#---------------------------------------------
# Part 2
#---------------------------------------------
keypad = [[None, None, '1', None, None]
        ,[None, '2', '3', '4', None]
        ,['5', '6', '7', '8', '9']
        ,[None, 'A', 'B', 'C', None]
        ,[None, None, 'D', None, None]]

l = len(keypad)-1
answer_2 = ''

for i, line in enumerate(aoc_input):
    button = '5' if i==0 else answer_2[-1]
    k1, k2 = [(ip1, ip2) for ip1, p1 in enumerate(keypad) for ip2, p2 in enumerate(p1) if p2==button][0]

    for i2, command in enumerate(line):
        k1, k2 = check_index_part_2(k1, k2, command)

    answer_2 += str(keypad[k1][k2])

print ('Part 2 Answer:', answer_2)
