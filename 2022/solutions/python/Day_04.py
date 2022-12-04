#---------------------------------------------
# Author:       Elaine Lin
# Created Date: 2022-12-04
# References Used:
#---------------------------------------------

import os
from pathlib import Path

file_name = ((os.path.basename(__file__)).split('.')[0])
base_path = Path(__file__).parent.parent
file_path = (base_path / '../inputs/{0}.txt'.format(file_name)).resolve()

aoc_input = []

with open(file_path) as file:
    aoc_input = [line.strip() for line in file]

#---------------------------------------------
# Test Scenario
#---------------------------------------------
# aoc_input = """2-4,6-8
# 2-3,4-5
# 5-7,7-9
# 2-8,3-7
# 6-6,4-6
# 2-6,4-8"""
# aoc_input = aoc_input.split('\n')

def solve(part: int) -> int:
    count = 0
    for assignment in aoc_input:
        elf_one, elf_two = assignment.split(',')
        start_one, end_one = map(int, elf_one.split('-'))
        start_two, end_two = map(int, elf_two.split('-'))
        if part==1 and ((start_one<=start_two and end_one>=end_two) or (start_two<=start_one and end_two>=end_one)):
            count += 1
        if part==2 and (end_two>=start_one and end_one>=start_two):
            count += 1
    return count

#---------------------------------------------
# Part 1
#---------------------------------------------
answer_1 = solve(part=1)

print ('Part 1 Answer:', answer_1)

#---------------------------------------------
# Part 2
#---------------------------------------------
answer_2 = solve(part=2)

print ('Part 2 Answer:', answer_2)
