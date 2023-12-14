import os
from pathlib import Path

file_name = ((os.path.basename(__file__)).split('.')[0])
base_path = Path(__file__).parent.parent
file_path = (base_path / '../inputs/{0}.txt'.format(file_name)).resolve()

with open(file_path) as file:
    raw_input = file.read().splitlines()

def next_number(part: int, numbers: list, anchor_number: int, add: int, depth: int):
    # print (f"{numbers = } | {numbers = } | {anchor_number = } | {add = } | {depth = }")
    if all([n==0 for n in numbers]):
        return anchor_number+add
    numbers = [numbers[i+1]-numbers[i] for i in range(len(numbers)-1)]
    multiplier = 1 if part==1 else (-1 if depth%2==0 else 1)
    add += (numbers[-1 if part==1 else 0])*multiplier
    return next_number(part=part, numbers=numbers, anchor_number=anchor_number, add=add, depth=depth+1)

def solve(part: int) -> int:
    answer = 0
    for line in raw_input:
        numbers = [int(n) for n in line.split()]
        answer += (next_number(part=part, numbers=numbers, anchor_number=(numbers[-1 if part==1 else 0]), add=0, depth=0))
    return answer
        
print (f"answer 1: {solve(part=1)}")
print (f"answer 2: {solve(part=2)}")
