#---------------------------------------------
# Author:       Elaine Lin
# Created Date: 2021-11-22
# References Used:
#   https://stackoverflow.com/questions/14962485/finding-a-key-recursively-in-a-dictionary
#   https://stackoverflow.com/questions/11941817/how-to-avoid-runtimeerror-dictionary-changed-size-during-iteration-error
#---------------------------------------------

from collections import defaultdict
import os
from pathlib import Path

file_name = ((os.path.basename(__file__)).split('.')[0])
base_path = Path(__file__).parent.parent
file_path = (base_path / '../inputs/{0}.txt'.format(file_name)).resolve()

aoc_input = [i for i in open(file_path).read().split('\n')]

#---------------------------------------------
# Test Scenario (Part 1)
#---------------------------------------------
# aoc_input = """COM)B
# B)C
# C)D
# D)E
# E)F
# B)G
# G)H
# D)I
# E)J
# J)K
# K)L"""
# aoc_input = aoc_input.split('\n')
# print (aoc_input)

#---------------------------------------------
# Test Scenario (Part 2)
#---------------------------------------------
# aoc_input = """COM)B
# B)C
# C)D
# D)E
# E)F
# B)G
# G)H
# D)I
# E)J
# J)K
# K)L
# K)YOU
# I)SAN"""
# aoc_input = aoc_input.split('\n')
# print (aoc_input)

#---------------------------------------------
# Part 1
#---------------------------------------------
#populate orbits dictionary (one-way)
orbits = defaultdict(str)
for orbit in aoc_input:
    obj_1, obj_2 = orbit.split(')')
    orbits[obj_2] = obj_1

#get count of direct and indirect orbits
def find_orbits(key, orbits, count):
    value = orbits[key]
    if not value:
        return count
    return find_orbits(value, orbits, count+1)

answer_1 = sum([find_orbits(key, orbits, 0) for key in list(orbits.keys())]) #for each orbit, get count of direct and indirect orbits

print ('Part 1 Answer:', answer_1)

#---------------------------------------------
# Part 2
#---------------------------------------------
#populate orbits dictionary (two-way) #need to be able to traverse orbits forwards and backwards
orbits = defaultdict(list)
for orbit in aoc_input:
    obj_1, obj_2 = orbit.split(')')
    orbits[obj_1].append(obj_2)
    orbits[obj_2].append(obj_1)

def find_you_to_san(key, orbits, count, visited):
    visited.add(key)
    value = orbits[key]
    if 'SAN' in value:
        return count
    for v in value:
        if v not in visited:
            fyts = find_you_to_san(v, orbits, count+1, visited)
            if fyts:
                return fyts

start = ''.join(orbits['YOU']) #start with the orbit around 'YOU'
visited = set() #keep track of all the orbits we have visited to avoid infinite loop (do not revisit same orbits)

answer_2 = find_you_to_san(start, orbits, 0, visited)

print ('Part 2 Answer:', answer_2)
