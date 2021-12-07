#---------------------------------------------
# Author:       Elaine Lin
# Created Date: 2021-12-06
# References Used:
#---------------------------------------------

from collections import defaultdict
import os
from pathlib import Path

file_name = ((os.path.basename(__file__)).split('.')[0])
base_path = Path(__file__).parent.parent
file_path = (base_path / '../inputs/{0}.txt'.format(file_name)).resolve()

aoc_input = [int(i) for i in open(file_path).read().split(',')]

#---------------------------------------------
# Test Scenario
#---------------------------------------------
# aoc_input = [16,1,2,0,4,2,7,1,2,14]

def solve(input: list, part: int) -> int:
    max_position = max(input)
    total_fuel = defaultdict(int)
    for i in range(max_position):
        if part==1: total_fuel[i] = sum([abs(c-i) for c in aoc_input])
        if part==2: total_fuel[i] = sum([abs(c-i)*(abs(c-i)+1)/2 for c in aoc_input])
    return int(min(total_fuel.values()))

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
