#---------------------------------------------
# Author:       Elaine Lin
# Created Date: 2021-11-20
# References Used:
#---------------------------------------------

from collections import defaultdict
import os
from pathlib import Path

file_name = ((os.path.basename(__file__)).split('.')[0])
base_path = Path(__file__).parent.parent
file_path = (base_path / '../inputs/{0}.txt'.format(file_name)).resolve()

aoc_input = [int(i) for i in open(file_path).read().split(',')]

def solve_pos_0(intcode, input, diagnostic_code):
    i = 0
    while i < len(intcode):
        opcode = intcode[i]

        if opcode == 99:
            break
        if opcode == 3:
            intcode[intcode[i+1]] = input
        if opcode == 4:
            diagnostic_code = intcode[intcode[i+1]]
            print (diagnostic_code)

        str_opcode = str(opcode)
        len_opcode = len(str_opcode)
        parameter_modes = defaultdict(int)
        if len_opcode > 2:
            #last two digits is now the opcode
            opcode = int(str_opcode[-2:])
            #getting the parameter modes for the subsequent parameters
            c = 0
            for j in range(len_opcode-3, -1, -1):
                parameter_modes[c] = int(str_opcode[j])
                c += 1

        if opcode in [1, 2, 5, 6, 7, 8]:
            pos_1 = intcode[i+1] if parameter_modes.get(0, 0)==1 else intcode[intcode[i+1]]
            pos_2 = intcode[i+2] if parameter_modes.get(1, 0)==1 else intcode[intcode[i+2]]
            
            if opcode == 1:
                intcode[intcode[i+3]] = (pos_1+pos_2)
            elif opcode == 2:
                intcode[intcode[i+3]] = (pos_1*pos_2)
            elif (opcode == 5 and pos_1 != 0) or (opcode == 6 and pos_1 == 0):
                i = pos_2
                continue
            elif opcode == 7:
                intcode[intcode[i+3]] = 1 if pos_1<pos_2 else 0
            elif opcode == 8:
                intcode[intcode[i+3]] = 1 if pos_1==pos_2 else 0

        inc = 0
        if opcode in [1, 2, 7, 8]:
            inc = 4
        elif opcode in [3, 4]:
            inc = 2
        elif opcode in [5, 6]:
            inc = 3
        i += inc
    
    return diagnostic_code

#---------------------------------------------
# Part 1
#---------------------------------------------
diagnostic_code = None
system_input = 1
answer_1 = solve_pos_0(aoc_input.copy(), system_input, diagnostic_code)

print ('Part 1 Answer:', answer_1)

#---------------------------------------------
# Part 2
#---------------------------------------------
diagnostic_code = None
system_input = 5
answer_2 = solve_pos_0(aoc_input.copy(), system_input, diagnostic_code)

print ('Part 2 Answer:', answer_2)
