#---------------------------------------------
# Author:       Elaine Lin
# Created Date: 2021-04-04
# References Used:
#   (Part 2) https://stackoverflow.com/questions/31687185/why-is-this-python-generator-returning-the-same-value-everytime
#   (Part 2) https://stackoverflow.com/questions/189645/how-to-break-out-of-multiple-loops
#---------------------------------------------

import os
from pathlib import Path

file_name = ((os.path.basename(__file__)).split('.')[0])
base_path = Path(__file__).parent.parent
file_path = (base_path / '../inputs/{0}.txt'.format(file_name)).resolve()

aoc_input = None

with open(file_path) as file:
    aoc_input = file.read().split(', ')

#---------------------------------------------
# Test Scenario
#---------------------------------------------
# test = 'R5, L5, R5, R3'
# test = 'R8, R4, R4, R8'

# aoc_input = [i.strip() for i in test.split(',')]
# print (aoc_input)

def get_current_direction(direction, lr):
    dir = ['north', 'east', 'south', 'west']
    cur_dir = dir.index(direction)
    new_dir = (cur_dir+(1 if lr=='R' else -1))%4
    return (dir[new_dir])

#---------------------------------------------
# Part 1
#---------------------------------------------
def solve_part_1():
    direction = 'north'
    coordinates = [0, 0]

    for instruction in aoc_input:
        lr, num = instruction[0], instruction[1:]
        direction = get_current_direction(direction, lr)
        if direction in ['east', 'west']:
            coordinates[0] += int(num)*(1 if direction=='east' else -1)
        if direction in ['north', 'south']:
            coordinates[1] += int(num)*(1 if direction=='north' else -1)

    return (abs(coordinates[0]) + abs(coordinates[1]))

answer_1 = solve_part_1()

print ('Part 1 Answer:', answer_1)

#---------------------------------------------
# Part 2
#---------------------------------------------
def solve_part_2():
    direction = 'north'
    coordinates = [0, 0]
    visited_coordinates = [[0, 0]]

    for instruction in aoc_input:
        lr, num = instruction[0], instruction[1:]
        direction = get_current_direction(direction, lr)
        for i in range(int(num)):
            coordinates[0] += (1 if direction=='east' else 0) + (-1 if direction=='west' else 0)
            coordinates[1] += (1 if direction=='north' else 0) + (-1 if direction=='south' else 0)
            if coordinates in visited_coordinates:
                return (abs(coordinates[0]) + abs(coordinates[1]))
            else:
                visited_coordinates.append(coordinates.copy())

answer_2 = solve_part_2()

print ('Part 2 Answer:', answer_2)
