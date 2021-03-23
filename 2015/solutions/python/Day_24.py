#---------------------------------------------
# Author:       Elaine Lin
# Created Date: 2021-03-22
# References Used:
#---------------------------------------------

import math
import itertools
import os
from pathlib import Path

file_name = ((os.path.basename(__file__)).split('.')[0])
base_path = Path(__file__).parent.parent
file_path = (base_path / '../inputs/{0}.txt'.format(file_name)).resolve()

aoc_input = None

with open(file_path) as file:
    aoc_input = [int(line.strip()) for line in file]


def solve(weight):
    valid_combos = []
    for i in range(1, len(aoc_input)):
        for combo in itertools.combinations(aoc_input, i):
            if sum(combo)==weight:
                valid_combos.append(combo)
        # only care about Group 1, which needs to have as few packages as possible
        if valid_combos:
            break
    return (min([math.prod(i) for i in valid_combos]))

#---------------------------------------------
# Part 1
#---------------------------------------------
thirds = (sum(aoc_input)/3)

print ('Part 1 Answer:', solve(thirds))

#---------------------------------------------
# Part 2
#---------------------------------------------
fourths = (sum(aoc_input)/4)

print ('Part 2 Answer:', solve(fourths))
