#---------------------------------------------
# Author:       Elaine Lin
# Created Date: 2021-01-15
# References Used:
#   https://www.geeksforgeeks.org/permutation-and-combination-in-python/
#---------------------------------------------

from collections import defaultdict
from itertools import permutations
import os
from pathlib import Path

file_name = ((os.path.basename(__file__)).split('.')[0])
base_path = Path(__file__).parent.parent
file_path = (base_path / '../inputs/{0}.txt'.format(file_name)).resolve()

aoc_input = []

with open(file_path) as file:
    for line in file:
        aoc_input.append(line.strip())

places = defaultdict(dict)
for i, s in enumerate(aoc_input):
    place, distance = s.split(' = ')
    p1, p2 = place.split(' to ')
    
    places[p1][p2] = int(distance)
    places[p2][p1] = int(distance)

distances = []
for travel_path in permutations(places):
    length = 0
    for i in range(len(travel_path)-1):
        start = travel_path[i]
        dest = travel_path[i+1]
        length += places[start][dest]
    distances.append(length)
    
#---------------------------------------------
# Part 1
#---------------------------------------------
answer = min(distances)
    
print ('Part 1 Answer:', answer)

#---------------------------------------------
# Part 2
#---------------------------------------------
answer = max(distances)

print ('Part 2 Answer:', answer)
