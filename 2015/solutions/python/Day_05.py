from aocd.models import Puzzle
from collections import Counter

puzzle = Puzzle(year=2015, day=5)

vowels = ['a', 'e', 'i', 'o', 'u']
disallowed = ['ab', 'cd', 'pq', 'xy']

puzzle.answer_a = sum([1 for _ in puzzle.input_data.splitlines() if sum([_.count(v) for v in vowels])>=3 and any([len(Counter(_[i:i+2]))==1 for i in range(len(_)-1)]) and all([d not in _ for d in disallowed])])
puzzle.answer_b = sum([1 for _ in puzzle.input_data.splitlines() if any([_.count(_[i:i+2])>=2 for i in range(len(_)-1)]) and any([_[i]==_[i+2] for i in range(len(_)-2)])])
