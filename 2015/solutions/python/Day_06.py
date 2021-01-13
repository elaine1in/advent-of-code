#---------------------------------------------
# Author:       Elaine Lin
# Created Date: 2021-01-11
# References Used:
#   https://realpython.com/regex-python/
#   https://stackoverflow.com/questions/29694826/updating-a-dictionary-in-python
#   https://stackoverflow.com/questions/42438808/finding-all-the-keys-with-the-same-value-in-a-python-dictionary
#---------------------------------------------

import re
from pathlib import Path

base_path = Path(__file__).parent.parent
file_path = (base_path / '../inputs/Day_06.txt').resolve()

aoc_input = []

with open(file_path) as file:
    for line in file:
        aoc_input.append(line.strip())

line_regex = re.compile(r'^((?:toggle|turn on|turn off)) ([0-9]{1,3},[0-9]{1,3}) through ([0-9]{1,3},[0-9]{1,3})$')
#---------------------------------------------
# Part 1
#---------------------------------------------
lights = {}
for i in range(1000):
    for j in range(1000):
        lights[i,j] = 0        

for line in aoc_input:
    match = line_regex.search(line)

    action = match.group(1)
    coordinate_start = match.group(2)
    coordinate_end = match.group(3)
    
    coordinate_start_x, coordinate_start_y = coordinate_start.split(',')
    coordinate_end_x, coordinate_end_y = coordinate_end.split(',')
    
    coordinate_start_x = int(coordinate_start_x)
    coordinate_start_y = int(coordinate_start_y)
    coordinate_end_x = int(coordinate_end_x)
    coordinate_end_y = int(coordinate_end_y)
    
    for i in range(coordinate_start_x, coordinate_end_x+1):
        for j in range(coordinate_start_y, coordinate_end_y+1):
            current_value = lights.get((i,j))
            if action=='toggle':
                lights.update({(i,j): 1 if current_value==0 else 0})
            elif action=='turn on':
                lights.update({(i,j): 1})
            elif action=='turn off':
                lights.update({(i,j): 0})

answer = len([k for k,v in lights.items() if v==1])
print ('Part 1 Answer:', answer)

#---------------------------------------------
# Part 2
#---------------------------------------------
lights = {}
for i in range(1000):
    for j in range(1000):
        lights[i,j] = 0        

for line in aoc_input:
    match = line_regex.search(line)

    action = match.group(1)
    coordinate_start = match.group(2)
    coordinate_end = match.group(3)
    
    coordinate_start_x, coordinate_start_y = coordinate_start.split(',')
    coordinate_end_x, coordinate_end_y = coordinate_end.split(',')
    
    coordinate_start_x = int(coordinate_start_x)
    coordinate_start_y = int(coordinate_start_y)
    coordinate_end_x = int(coordinate_end_x)
    coordinate_end_y = int(coordinate_end_y)
    
    for i in range(coordinate_start_x, coordinate_end_x+1):
        for j in range(coordinate_start_y, coordinate_end_y+1):
            current_value = lights.get((i,j))
            if action=='toggle':
                lights.update({(i,j): current_value+2})
            elif action=='turn on':
                lights.update({(i,j): current_value+1})
            elif action=='turn off':
                lights.update({(i,j): 0 if current_value==0 else current_value-1})

answer = sum([v for k,v in lights.items()])
print ('Part 2 Answer:', answer)
