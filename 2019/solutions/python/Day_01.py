#---------------------------------------------
# Author:       Elaine Lin
# Created Date: 2021-09-18
# References Used:
#---------------------------------------------

import math
import os
from pathlib import Path

file_name = ((os.path.basename(__file__)).split('.')[0])
base_path = Path(__file__).parent.parent
file_path = (base_path / '../inputs/{0}.txt'.format(file_name)).resolve()

aoc_input = []

with open(file_path) as file:
    aoc_input = [int(line.strip()) for line in file]

def total_fuel(module: int, fuel: int) -> int:
    module = math.floor(module/3)-2
    if module<=0:
        return fuel
    fuel += module
    return total_fuel(module, fuel)

#---------------------------------------------
# Part 1
#---------------------------------------------
answer_1 = sum([math.floor(module/3)-2 for module in aoc_input])

print ('Part 1 Answer:', answer_1)

#---------------------------------------------
# Part 2
#---------------------------------------------
answer_2 = sum([total_fuel(module, 0) for module in aoc_input])

print ('Part 2 Answer:', answer_2)
