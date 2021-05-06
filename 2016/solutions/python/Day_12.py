#---------------------------------------------
# Author:       Elaine Lin
# Created Date: 2021-05-02
# References Used:
#---------------------------------------------

from collections import defaultdict
import os
from pathlib import Path

file_name = ((os.path.basename(__file__)).split('.')[0])
base_path = Path(__file__).parent.parent
file_path = (base_path / '../inputs/{0}.txt'.format(file_name)).resolve()

aoc_input = None
    
with open(file_path) as file:
    aoc_input = [line.strip() for line in file]

#---------------------------------------------
# Test Scenario
#---------------------------------------------
# aoc_input = """cpy 41 a
# inc a
# inc a
# dec a
# jnz a 2
# dec a""".split('\n')

def solve(ix):
    while True:
        if ix>=len(aoc_input):
            break

        instruction = aoc_input[ix]

        if instruction[:3] in ['cpy', 'jnz']:
            command, x, y = instruction.split(' ')
            if command=='cpy':
                registers[y] = (int(x) if x.isnumeric() else registers[x])
            elif command=='jnz':
                if (int(x) if x.isnumeric() else registers[x])!=0:
                    ix += int(y)
                    continue
        elif instruction[:3] in ['inc', 'dec']:
            command, x = instruction.split(' ')
            registers[x] += 1 if command=='inc' else -1

        ix += 1
    return registers['a']

#---------------------------------------------
# Part 1
#---------------------------------------------
registers = defaultdict(int)
answer_1 = solve(0)

print ('Part 1 Answer:', answer_1)

#---------------------------------------------
# Part 2
#---------------------------------------------
registers = defaultdict(int)
registers['c'] = 1
answer_2 = solve(0)

print ('Part 2 Answer:', answer_2)
