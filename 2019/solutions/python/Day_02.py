#---------------------------------------------
# Author:       Elaine Lin
# Created Date: 2021-09-19
# References Used:
#---------------------------------------------

import os
from pathlib import Path

file_name = ((os.path.basename(__file__)).split('.')[0])
base_path = Path(__file__).parent.parent
file_path = (base_path / '../inputs/{0}.txt'.format(file_name)).resolve()

aoc_input = [int(i) for i in open(file_path).read().split(',')]

def solve_pos_0(intcode):
    for i in range(0, len(intcode), 4):
        opcode = intcode[i]
        if opcode == 99:
            break
        pos_1 = intcode[intcode[i+1]]
        pos_2 = intcode[intcode[i+2]]
        if opcode in [1, 2]:
            v = (pos_1+pos_2) if opcode==1 else (pos_1*pos_2)
            intcode[intcode[i+3]] = v
    return intcode[0]

def solve(part, intcode):
    if part == 1:
        intcode[1] = 12
        intcode[2] = 2
        return solve_pos_0(intcode.copy())
    if part == 2:
        for noun in range(0, 100):
            for verb in range(0, 100):
                intcode[1] = noun
                intcode[2] = verb
                if solve_pos_0(intcode.copy()) == 19690720:
                    return (100*noun+verb)

#---------------------------------------------
# Part 1
#---------------------------------------------
answer_1 = solve(1, aoc_input)

print ('Part 1 Answer:', answer_1)

#---------------------------------------------
# Part 2
#---------------------------------------------
answer_2 = solve(2, aoc_input)

print ('Part 2 Answer:', answer_2)
