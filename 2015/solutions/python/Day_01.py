from aocd.models import Puzzle

puzzle = Puzzle(year=2015, day=1)

puzzle.answer_a = sum([1 if _=="(" else -1 for _ in puzzle.input_data])
puzzle.answer_b = min([i for i in range(len(puzzle.input_data)) if sum([1 if _=="(" else -1 for _ in puzzle.input_data[:i]])==-1])
