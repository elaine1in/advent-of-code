from aocd.models import Puzzle

puzzle = Puzzle(year=2015, day=2)

puzzle.answer_a = sum([(2*l*w)+(2*w*h)+(2*h*l)+(min((l*w),(w*h),(h*l))) for _ in puzzle.input_data.splitlines() for l,w,h in [[int(v) for v in _.split("x")]]])
puzzle.answer_b = sum([(l*w*h)+(2*min((l+w),(w+h),(h+l))) for _ in puzzle.input_data.splitlines() for l,w,h in [[int(v) for v in _.split("x")]]])
