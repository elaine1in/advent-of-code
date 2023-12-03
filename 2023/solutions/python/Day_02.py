import os
from collections import defaultdict
from functools import reduce
from pathlib import Path

file_name = ((os.path.basename(__file__)).split('.')[0])
base_path = Path(__file__).parent.parent
file_path = (base_path / '../inputs/{0}.txt'.format(file_name)).resolve()

with open(file_path) as file:
    raw_input = file.read().splitlines()

def solve(part: int) -> int:
    puzzle_cubes = {"red": 12, "green": 13, "blue": 14}
    games = defaultdict(lambda: defaultdict(list))
    for game in raw_input:
        game_num, subsets = game.split(": ")
        num = int(game_num.replace("Game ", ""))
        smaller_subsets = [i for subset in subsets.split("; ") for i in subset.split(", ")]
        for cubes in smaller_subsets:
            num_of_cubes, cube_color = cubes.split()
            games[num][cube_color].append(int(num_of_cubes))

    answer = 0
    for k, v in games.items():
        # print (f"{k = }, {v = }")
        if part == 1:
            answer += k if all([(n <= num) for color, num in puzzle_cubes.items() for n in v[color]]) else 0
        if part == 2:
            answer += reduce(lambda x, y: x*y, [max(num) for num in v.values()])

    return answer

print (f"answer: {solve(part=1)}")
print (f"answer: {solve(part=2)}")
