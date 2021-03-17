#---------------------------------------------
# Author:       Elaine Lin
# Created Date: 2021-03-16
# References Used:
#---------------------------------------------

import math
import itertools
from collections import defaultdict
import os
from pathlib import Path

file_name = ((os.path.basename(__file__)).split('.')[0])
base_path = Path(__file__).parent.parent
file_path = (base_path / '../inputs/{0}.txt'.format(file_name)).resolve()

aoc_input = None

with open(file_path) as file:
    aoc_input = [line.strip() for line in file]

registers = defaultdict(int)

def solve():
    counter = 0
    while counter < len(aoc_input):
        command = aoc_input[counter][:3]
        other = aoc_input[counter][3:].strip()

        if command=='hlf':
            registers[other] /= 2
            counter += 1
        elif command=='tpl':
            registers[other] *= 3
            counter += 1
        elif command=='inc':
            registers[other] += 1
            counter += 1
        elif command=='jmp':
            counter += int(other)
        elif command=='jie':
            register, num = other.split(', ')
            counter += int(num) if registers[register]%2==0 else 1
        elif command=='jio':
            register, num = other.split(', ')
            counter += int(num) if registers[register]==1 else 1
    return (registers['b'])

#---------------------------------------------
# Part 1
#---------------------------------------------
registers['a'] = 0
registers['b'] = 0

print ('Part 1 Answer:', solve())

#---------------------------------------------
# Part 2
#---------------------------------------------
registers['a'] = 1
registers['b'] = 0

print ('Part 2 Answer:', solve())
