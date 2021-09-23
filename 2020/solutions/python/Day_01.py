#---------------------------------------------
# Author:       Elaine Lin
# Created Date: 2020-12-19
# References Used:
#   https://stackoverflow.com/questions/40416072/reading-file-using-relative-path-in-python-project
#   https://stackoverflow.com/questions/464864/how-to-get-all-possible-combinations-of-a-list-s-elements
#   https://stackoverflow.com/questions/3925614/how-do-you-read-a-file-into-a-list-in-python
#   https://stackoverflow.com/questions/13840379/how-can-i-multiply-all-items-in-a-list-together-with-python
#---------------------------------------------

import itertools
import numpy as np
import os
from pathlib import Path

file_name = ((os.path.basename(__file__)).split('.')[0])
base_path = Path(__file__).parent.parent
file_path = (base_path / '../inputs/{0}.txt'.format(file_name)).resolve()

aoc_input = [int(line) for line in open(file_path).read().split('\n')]

def solve(r, number):
    return sum([np.prod(i) for i in itertools.combinations(aoc_input, r) if sum(i)==number])

#---------------------------------------------
# Part 1
#---------------------------------------------
answer_1 = solve(2, 2020)

print ('Part 1 Answer:', answer_1)
        
#---------------------------------------------
# Part 2
#---------------------------------------------
answer_2 = solve(3, 2020)

print ('Part 2 Answer:', answer_2)
