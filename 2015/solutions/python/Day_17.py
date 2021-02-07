#---------------------------------------------
# Author:       Elaine Lin
# Created Date: 2021-02-06
# References Used: 
#---------------------------------------------

import os
from pathlib import Path
import itertools

file_name = ((os.path.basename(__file__)).split('.')[0])
base_path = Path(__file__).parent.parent
file_path = (base_path / '../inputs/{0}.txt'.format(file_name)).resolve()

aoc_input = []

with open(file_path) as file:
    for line in file:
        aoc_input.append(int(line))

combos = []
for i in range(1, len(aoc_input)+1):
    for j in itertools.combinations(aoc_input, i):
        combos.append(j)

#---------------------------------------------
# Part 1
#---------------------------------------------
answer = sum([1 for i in combos if sum(i)==150])

print ('Part 1 Answer:', answer)

#---------------------------------------------
# Part 2
#---------------------------------------------
min_num_containers = min([len(i) for i in combos if sum(i)==150])
answer = sum([1 for i in combos if sum(i)==150 and len(i)==min_num_containers])

print ('Part 2 Answer:', answer)
