#---------------------------------------------
# Author:       Elaine Lin
# Created Date: 2021-01-07
# References Used:
#   https://stackoverflow.com/questions/35906411/list-on-python-appending-always-the-same-value
#   https://stackoverflow.com/questions/3724551/python-uniqueness-for-list-of-lists
#---------------------------------------------

from pathlib import Path

base_path = Path(__file__).parent.parent
file_path = (base_path / '../inputs/Day_03.txt').resolve()

aoc_input = []

with open(file_path) as file:
    aoc_input = file.read()

#---------------------------------------------
# Part 1
#---------------------------------------------
coordinates = [0, 0]
houses = []
for i in range(len(aoc_input)):
    if aoc_input[i] == '^':
        coordinates[1] += 1
    elif aoc_input[i] == 'v':
        coordinates[1] -= 1
    elif aoc_input[i] == '>':
        coordinates[0] += 1
    elif aoc_input[i] == '<':
        coordinates[0] -= 1
        
    houses.append([coordinates[0], coordinates[1]])

answer = len([list(x) for x in set(tuple(x) for x in houses)]) + 1 #need to +1 to include house at starting location
print ('Part 1 Answer:', answer)

#---------------------------------------------
# Part 2
#---------------------------------------------
ss_coordinates = [0, 0]
rs_coordinates = [0, 0]
houses = []
for i in range(len(aoc_input)):
    if i%2==0:
        if aoc_input[i] == '^':
            ss_coordinates[1] += 1
        elif aoc_input[i] == 'v':
            ss_coordinates[1] -= 1
        elif aoc_input[i] == '>':
            ss_coordinates[0] += 1
        elif aoc_input[i] == '<':
            ss_coordinates[0] -= 1
    else:
        if aoc_input[i] == '^':
            rs_coordinates[1] += 1
        elif aoc_input[i] == 'v':
            rs_coordinates[1] -= 1
        elif aoc_input[i] == '>':
            rs_coordinates[0] += 1
        elif aoc_input[i] == '<':
            rs_coordinates[0] -= 1
            
    houses.append([ss_coordinates[0], ss_coordinates[1]] if i%2==0 else [rs_coordinates[0], rs_coordinates[1]])
 
answer = len([list(x) for x in set(tuple(x) for x in houses)])
print ('Part 2 Answer:', answer)
