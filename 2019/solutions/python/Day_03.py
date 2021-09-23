#---------------------------------------------
# Author:       Elaine Lin
# Created Date: 2021-09-22
# References Used:
#   https://www.programiz.com/python-programming/methods/set/remove
#---------------------------------------------

import os
from pathlib import Path

file_name = ((os.path.basename(__file__)).split('.')[0])
base_path = Path(__file__).parent.parent
file_path = (base_path / '../inputs/{0}.txt'.format(file_name)).resolve()

instruction_one, instruction_two  = [line for line in open(file_path).read().split('\n')]
instruction_one = instruction_one.split(',')
instruction_two = instruction_two.split(',')

def instruction_coordinates(instructions: list, current_coordinate: list, coordinates: list):
    for instruction in instructions:
        direction = instruction[0]
        num = int(instruction[1:])

        if direction in ['R', 'L']:
            current_coordinate[0] += num if direction=='R' else -num
        if direction in ['U', 'D']:
            current_coordinate[1] += num if direction=='U' else -num

        last_coordinate = coordinates[-1]

        def append_coordinates(last_coordinate, current_coordinate, xy):
            xy_index = 0 if xy=='x' else 1
            xy_min = min(last_coordinate[xy_index], current_coordinate[xy_index])
            xy_max = max(last_coordinate[xy_index], current_coordinate[xy_index])

            range_start = xy_min+1 if current_coordinate[xy_index]==xy_max else xy_max-1
            range_end = xy_max+1 if current_coordinate[xy_index]==xy_max else xy_min-1
            step = 1 if current_coordinate[xy_index]==xy_max else -1

            if xy_min!=xy_max:
                for i in range(range_start, range_end, step):
                    coordinates.append((i, current_coordinate[1])) if xy=='x' else coordinates.append((current_coordinate[0], i))

        append_coordinates(last_coordinate, current_coordinate, 'x')
        append_coordinates(last_coordinate, current_coordinate, 'y')

    return coordinates

wire_one_coordinates = instruction_coordinates(instruction_one, [0,0], [(0,0)])
wire_two_coordinates = instruction_coordinates(instruction_two, [0,0], [(0,0)])
crossed_coordinates = set(wire_one_coordinates) & set(wire_two_coordinates)
crossed_coordinates.remove((0,0))

#---------------------------------------------
# Part 1
#---------------------------------------------
answer_1 = min([abs(x)+abs(y) for x, y in crossed_coordinates])

print ('Part 1 Answer:', answer_1)

#---------------------------------------------
# Part 2
#---------------------------------------------
answer_2 = min([wire_one_coordinates.index(coordinate)+wire_two_coordinates.index(coordinate) for coordinate in crossed_coordinates])

print ('Part 2 Answer:', answer_2)
