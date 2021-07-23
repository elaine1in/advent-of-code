#---------------------------------------------
# Author:       Elaine Lin
# Created Date: 2021-07-22
# References Used:
#   https://stackoverflow.com/questions/19189274/nested-defaultdict-of-defaultdict
#---------------------------------------------

from collections import defaultdict
import re
import os
from pathlib import Path

file_name = ((os.path.basename(__file__)).split('.')[0])
base_path = Path(__file__).parent.parent
file_path = (base_path / '../inputs/{0}.txt'.format(file_name)).resolve()

aoc_input = None
    
with open(file_path) as file:
    aoc_input = [line.strip() for line in file]

discs = defaultdict(lambda: defaultdict(dict))

for line in aoc_input:

    regex_pattern = re.match(r'Disc #([0-9]{1}) has ([0-9]{1,2}) positions; at time=0, it is at position ([0-9]{1}).', line)

    # print (regex_pattern.groups())
    disc = int(regex_pattern.group(1))
    number_of_positions = int(regex_pattern.group(2))
    current_position = int(regex_pattern.group(3))

    discs[disc] = {'number_of_positions': number_of_positions, 'current_position': current_position}

def solve():
    time = 0
    while True:
        #(v['number_of_positions']-v['current_position']) is to determine how much time it takes to return back to position 0
        #subtract it from (time+k) so that we can just look for multiples of v['number_of_positions']
        #if mod 0, then we know it lands back at position 0
        if all([(((time+k)-(v['number_of_positions']-v['current_position']))%(v['number_of_positions'])==0) for k, v in discs.items()]):
            return time
        time += 1

#---------------------------------------------
# Part 1
#---------------------------------------------
answer_1 = solve()
print ('Part 1 Answer:', answer_1)

#---------------------------------------------
# Part 2
#---------------------------------------------
disc_num = max(discs.keys()) + 1
discs[disc_num] = {'number_of_positions': 11, 'current_position': 0}
answer_2 = solve()

print ('Part 2 Answer:', answer_2)
