#---------------------------------------------
# Author:       Elaine Lin
# Created Date: 2020-12-20
# References Used: 
#   https://www.geeksforgeeks.org/python-get-unique-values-list/
#   https://stackoverflow.com/questions/57210753/find-common-values-in-multiple-lists
#   https://www.tutorialspoint.com/find-common-elements-in-list-of-lists-in-python
#---------------------------------------------

import os
from pathlib import Path

file_name = ((os.path.basename(__file__)).split('.')[0])
base_path = Path(__file__).parent.parent
file_path = (base_path / '../inputs/{0}.txt'.format(file_name)).resolve()

aoc_input = None

with open(file_path) as file:
    aoc_input = [line.strip() for line in file]

aoc_input.append('')

#---------------------------------------------
# Part 1
#---------------------------------------------
count_total = 0
s = ''

for i in aoc_input:
    if i == '':
        count_total += len(set(s))
        s = ''
    else:
        s += i
        
print ('Part 1 Answer:', count_total)

#---------------------------------------------
# Part 2
#---------------------------------------------
count_total = 0
s = []

for i in aoc_input:
    if i == '':
        count_total += len(list(set.intersection(*map(set, s))))
        s = []
    else:
        s.append(list(i))

print ('Part 2 Answer:', count_total)
