import os
import re
from collections import defaultdict
from pathlib import Path

file_name = ((os.path.basename(__file__)).split('.')[0])
base_path = Path(__file__).parent.parent
file_path = (base_path / '../inputs/{0}.txt'.format(file_name)).resolve()

with open(file_path) as file:
    raw_input = file.read().split(',')

def calculate_current_value(string: str) -> int:
    current_value = 0
    for char in string:
        current_value += ord(char)
        current_value *= 17
        current_value %= 256
    return current_value

def solve(part: int) -> int:
    if part == 1:
        return sum([calculate_current_value(step) for step in raw_input])
    if part == 2:
        boxes = defaultdict(lambda: defaultdict(int))
        for step in raw_input:
            label, focal_length = re.split(pattern="[=-]{1}", string=step)
            current_value = calculate_current_value(label)
            if focal_length:
                boxes[current_value][label] = int(focal_length)
            else:
                boxes[current_value].pop(label, None)
                
        answer = 0
        for k,v in boxes.items():
            for i, (k1,v1) in enumerate(v.items()):
                answer += (k+1) * (i+1) * v1   
        return answer

print (f"answer 1: {solve(part=1)}")
print (f"answer 2: {solve(part=2)}")
