#---------------------------------------------
# Author:       Elaine Lin
# Created Date: 2021-02-07
# References Used: 
#---------------------------------------------

from collections import defaultdict
import os
from pathlib import Path

file_name = ((os.path.basename(__file__)).split('.')[0])
base_path = Path(__file__).parent.parent
file_path = (base_path / '../inputs/{0}.txt'.format(file_name)).resolve()

aoc_input = []

with open(file_path) as file:
    aoc_input = file.read()

#---------------------------------------------
# Test Scenario
#---------------------------------------------
#aoc_input = """F10
#N3
#F7
#R90
#F11"""

aoc_input = aoc_input.split('\n')

#---------------------------------------------
# Part 1
#---------------------------------------------
directions = ['north', 'east', 'south', 'west']
directions_dictionary = {'north': 'N', 'east': 'E', 'south': 'S', 'west': 'W'}

coordinates = defaultdict(int)
for dir in directions:
    coordinates[dir] = 0

current_direction = 'east'

def new_direction(action, value, direction):
    value = (value/90) * (-1 if action=='L' else 1)
    i = directions.index(direction)
    
    idx = int((value+i)%4)
    return (directions[idx])
    
for i in aoc_input:
    action = i[0]
    value = int(i[1:])
    
    if action=='F':
        coordinates[current_direction] += value
    elif action in ['L', 'R']:
        current_direction = new_direction(action, value, current_direction)
    else:
        dn = ''.join([k for k, v in directions_dictionary.items() if v==action])
        coordinates[dn] += value

answer = (abs(coordinates['east']-coordinates['west']) + abs(coordinates['north']-coordinates['south']))

print ('Part 1 Answer:', answer)

#---------------------------------------------
# Part 2
#---------------------------------------------
waypoint = {'x': 10, 'y': 1}
ship = {'x': 0, 'y': 0}

for i in aoc_input:
    action = i[0]
    value = int(i[1:])

    if action=='F':
        ship['x'] += waypoint['x']*value
        ship['y'] += waypoint['y']*value
    elif action in ['E', 'W']:
        waypoint['x'] += (value if action=='E' else value*-1)
    elif action in ['N', 'S']:
        waypoint['y'] += (value if action=='N' else value*-1)
    elif action=='R':
        if (value/90)%4==0:
            pass
        elif (value/90)%4==1:
            waypoint = {'x': waypoint['y'], 'y': waypoint['x']*-1}
        elif (value/90)%4==2:
            waypoint = {'x': waypoint['x']*-1, 'y': waypoint['y']*-1}
        elif (value/90)%4==3:
            waypoint = {'x': waypoint['y']*-1, 'y': waypoint['x']}
    elif action=='L':
        if (value/90)%4==0:
            pass
        elif (value/90)%4==1:
            waypoint = {'x': waypoint['y']*-1, 'y': waypoint['x']}
        elif (value/90)%4==2:
            waypoint = {'x': waypoint['x']*-1, 'y': waypoint['y']*-1}
        elif (value/90)%4==3:
            waypoint = {'x': waypoint['y'], 'y': waypoint['x']*-1}

answer = sum([abs(v) for k, v in ship.items()])

print ('Part 2 Answer:', answer)
