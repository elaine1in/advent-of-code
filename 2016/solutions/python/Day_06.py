#---------------------------------------------
# Author:       Elaine Lin
# Created Date: 2021-03-11
# References Used:
#   https://pymotw.com/2/collections/counter.html
#---------------------------------------------

from collections import defaultdict, Counter
import os
from pathlib import Path

file_name = ((os.path.basename(__file__)).split('.')[0])
base_path = Path(__file__).parent.parent
file_path = (base_path / '../inputs/{0}.txt'.format(file_name)).resolve()

aoc_input = None

with open(file_path) as file:
    aoc_input = [line.strip() for line in file]

len_message = [len(message) for message in aoc_input]

assert min(len_message)==max(len_message)

position = defaultdict(str)

for i in range(max(len_message)):
    position[i] = ''.join([message[i] for message in aoc_input])

answer1 = ''
answer2 = ''

for k, v in position.items():
    answer1 += Counter(v).most_common(1)[0][0]
    answer2 += Counter(v).most_common()[-1][0]

#---------------------------------------------
# Part 1
#---------------------------------------------
print ('Part 1 Answer:', answer1)

#---------------------------------------------
# Part 2
#---------------------------------------------
print ('Part 2 Answer:', answer2)
