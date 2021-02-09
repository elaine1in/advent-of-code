#---------------------------------------------
# Author:       Elaine Lin
# Created Date: 2021-02-07
# References Used:
#   https://stackoverflow.com/questions/46024562/how-do-i-avoid-keyerror-when-working-with-dictionaries
#---------------------------------------------

import re
from collections import defaultdict
import os
from pathlib import Path

file_name = ((os.path.basename(__file__)).split('.')[0])
base_path = Path(__file__).parent.parent
file_path = (base_path / '../inputs/{0}.txt'.format(file_name)).resolve()

aoc_input = defaultdict(dict)
regexp = re.compile(r'(^[A-Za-z]+) can fly ([0-9]{1,2}) km/s for ([0-9]{1,2}) seconds, but then must rest for ([0-9]{1,3}) seconds.')

with open(file_path) as file:
    for line in file:
        match = regexp.search(line)
        
        reindeer = match.group(1)
        speed = int(match.group(2))
        duration = int(match.group(3))
        rest = int(match.group(4))
		
        aoc_input[reindeer].update({'speed': speed, 'duration': duration, 'rest': rest})
   
time = 2503

#---------------------------------------------
# Part 1
#---------------------------------------------
distances1 = defaultdict(int)
for k, v in aoc_input.items():
    speed = aoc_input[k]['speed']
    duration = aoc_input[k]['duration']
    rest = aoc_input[k]['rest']
    
    seconds = (duration+rest)
    iterations = (time//seconds)
    remaining = time-(iterations*seconds)
    
    distance = (iterations*speed*duration) + (speed*(duration if remaining>duration else remaining))
    
    distances1[k] = distance
    
answer = max([v for k, v in distances1.items()])
    
print ('Part 1 Answer:', answer)

#---------------------------------------------
# Part 2
#---------------------------------------------
distances2 = defaultdict(dict)
for i in range(1, time+1):
    for k, v in aoc_input.items():
        speed = aoc_input[k]['speed']
        duration = aoc_input[k]['duration']
        rest = aoc_input[k]['rest']
        
        total_distance = distances2[i-1].get(k, 0) + (speed if (((i-1)%(duration+rest))+1)<=duration else 0)
        distances2[i][k] = total_distance
        
del distances2[0]        
        
reindeers = defaultdict(int)
for k, v in distances2.items():
    mv = max([cv for ck, cv in v.items()])
    for rk, rv in v.items():
        if rv==mv:
            reindeers[rk] += 1

answer = max([v for k, v in reindeers.items()])

print ('Part 2 Answer:', answer)
