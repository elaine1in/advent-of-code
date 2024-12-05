from aocd.models import Puzzle
import hashlib

puzzle = Puzzle(year=2015, day=4)

string = puzzle.input_data
def solve(num):
    counter = 0
    while True:
        counter += 1
        if hashlib.md5(f"{string}{counter}".encode("utf-8")).hexdigest()[:num] == "0"*num:
            return (counter)

puzzle.answer_a = solve(5)
puzzle.answer_b = solve(6)
