import os
import re
import sys
from collections import defaultdict
from math import lcm
from pathlib import Path

file_name = ((os.path.basename(__file__)).split('.')[0])
base_path = Path(__file__).parent.parent
file_path = (base_path / '../inputs/{0}.txt'.format(file_name)).resolve()

with open(file_path) as file:
    raw_input = file.read().splitlines()

instructions = None
network_map = defaultdict(list)
for i, line in enumerate(raw_input):
    if i==0:
        instructions = line
    elif i==1:
        continue
    else:
        key, value = line.split(' = ')
        pattern = re.compile("\(([A-Z0-9]{3}), ([A-Z0-9]{3})\)")
        pattern_match = pattern.match(value)
        
        left_value = pattern_match.group(1)
        right_value = pattern_match.group(2)
        # print (f"{key = } // {left_value = } // {right_value = }")
        network_map[key] = [left_value, right_value]

# print (f"{instructions = }")
# print (f"{network_map = }")

def solve(part: int, counter: int, key: str):
    i = counter%len(instructions)
    key = network_map[key][0 if instructions[i]=='L' else 1]
    # print (f"{counter = } | {i = } | {instructions[i] = } | {key = }")
    if (part==1 and key=='ZZZ') or (part==2 and key.endswith('Z')):
        return counter+1
    return solve(part=part, counter=counter+1, key=key)

sys.setrecursionlimit(100000)
print (f"answer: {solve(part=1, counter=0, key='AAA')}")
print (f"answer: {lcm(*[solve(part=2, counter=0, key=k) for k in network_map.keys() if k.endswith('A')])}")
