#---------------------------------------------
# Author:       Elaine Lin
# Created Date: 2022-12-01
# References Used:
#---------------------------------------------

import os
from pathlib import Path

file_name = ((os.path.basename(__file__)).split('.')[0])
base_path = Path(__file__).parent.parent
file_path = (base_path / '../inputs/{0}.txt'.format(file_name)).resolve()

aoc_input = []

with open(file_path) as file:
    elf_calories = []
    for line in file:
        if line == '\n':
            aoc_input.append(sum(elf_calories))
            elf_calories = []
        else:
            elf_calories.append(int(line.strip()))

#---------------------------------------------
# Part 1
#---------------------------------------------
answer_1 = max(aoc_input)

print ('Part 1 Answer:', answer_1)

#---------------------------------------------
# Part 2
#---------------------------------------------
answer_2 = sum(sorted(aoc_input, reverse=True)[:3])

print ('Part 2 Answer:', answer_2)
