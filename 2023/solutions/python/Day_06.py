import os
from functools import reduce
from pathlib import Path

file_name = ((os.path.basename(__file__)).split('.')[0])
base_path = Path(__file__).parent.parent
file_path = (base_path / '../inputs/{0}.txt'.format(file_name)).resolve()

with open(file_path) as file:
    raw_input = file.read().splitlines()

def time_distance_mapping(part: int, raw_input: list) -> list:
    if part == 1:
        time = [int(i) for i in raw_input[0].split() if i.isdigit()]
        distance = [int(i) for i in raw_input[1].split() if i.isdigit()]
        return {t: d for t, d in zip(time, distance)}
    if part == 2:
        time = int("".join([i for i in raw_input[0].split() if i.isdigit()]))
        distance = int("".join([i for i in raw_input[1].split() if i.isdigit()]))
        return {time: distance}

def solve(part: int) -> int:
    td = time_distance_mapping(part=part, raw_input=raw_input)
    wins = []
    for k, v in td.items():
        wins.append(sum([((k-i)*i)>v for i in range(k)]))
    return reduce(lambda x, y: x*y, [_ for _ in wins])

print (f"answer 1: {solve(part=1)}")
print (f"answer 2: {solve(part=2)}")
