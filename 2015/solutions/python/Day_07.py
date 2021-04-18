#---------------------------------------------
# Author:       Elaine Lin
# Created Date: 2021-04-16
# References Used:
#   https://stackoverflow.com/questions/1602934/check-if-a-given-key-already-exists-in-a-dictionary
#---------------------------------------------

from collections import defaultdict
import os
from pathlib import Path

file_name = ((os.path.basename(__file__)).split('.')[0])
base_path = Path(__file__).parent.parent
file_path = (base_path / '../inputs/{0}.txt'.format(file_name)).resolve()

aoc_input = None

with open(file_path) as file:
    aoc_input = [line.strip() for line in file]

#---------------------------------------------
# Test Scenario
#---------------------------------------------
# aoc_input = [
#             '123 -> x'
#             ,'456 -> y'
#             ,'x AND y -> d'
#             ,'x OR y -> e'
#             ,'x LSHIFT 2 -> f'
#             ,'y RSHIFT 2 -> g'
#             ,'NOT x -> h'
#             ,'NOT y -> i'
#             ]

# print (aoc_input)

wires = defaultdict(int)

def starting_wires():
    # Starting wire(s) value
    for instruction in aoc_input:
        command, wire = instruction.split(' -> ')
        if command.isnumeric():
            wires[wire] = int(command)

def solve():
    # Traverse instructions for all other wires until wire 'a' has a signal
    while True:
        if 'a' in wires:
            return (wires['a'])
        else:
            for k, v in list(wires.items()):
                get_wire_value(k)

def get_wire_value(w):
    # Parse instructions to see if signal can be provided to wire
    for instruction in aoc_input:
        command, wire = instruction.split(' -> ')
        if w not in command.split(' '):
            continue
        else:
            if ' AND ' in command:
                pt1, pt2 = command.split(' AND ')
                if (pt1.isnumeric() or pt1 in wires) and pt2 in wires:
                    wires[wire] = (int(pt1) if pt1.isnumeric() else wires[pt1])&wires[pt2]
            elif ' OR ' in command:
                pt1, pt2 = command.split(' OR ')
                if pt1 in wires and pt2 in wires:
                    wires[wire] = wires[pt1]|wires[pt2]
            elif ' LSHIFT ' in command:
                pt1, pt2 = command.split(' LSHIFT ')
                if pt1 in wires:
                    wires[wire] = wires[pt1] << int(pt2)
            elif ' RSHIFT ' in command:
                pt1, pt2 = command.split(' RSHIFT ')
                if pt1 in wires:
                    wires[wire] = wires[pt1] >> int(pt2)
            elif 'NOT ' in command:
                pt1, pt2 = command.split('NOT ')[1], 65536
                if pt1 in wires:
                    wires[wire] = ~wires[pt1]+pt2
            else:
                wires[wire] = wires[command]

#---------------------------------------------
# Part 1
#---------------------------------------------
starting_wires()

answer_1 = solve()

print ('Part 1 Answer:', answer_1)

#---------------------------------------------
# Part 2
#---------------------------------------------
# Capture signal value of wire 'a' from Part 1 and then reset wires dictionary
override_b = wires['a']
wires = defaultdict(int)

# Starting wire(s) value
starting_wires()

# Override signal for wire 'b' with value of wire 'a' from Part 1
wires['b'] = override_b

answer_2 = solve()

print ('Part 2 Answer:', answer_2)
