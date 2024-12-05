from aocd.models import Puzzle

puzzle = Puzzle(year=2015, day=3)

x,y = 0,0
coordinates_a = [(0,0)]

for _ in puzzle.input_data:
    if _ in ["^", "v"]:
        y += (1 if _=="^" else -1)
    if _ in [">", "<"]:
        x += (1 if _==">" else -1)
    coordinates_a.append((x,y))
puzzle.answer_a = len(set(coordinates_a))

xs,ys = 0,0
xr,yr = 0,0
coordinates_b = [(0,0)]

for i, _ in enumerate(puzzle.input_data):
    if _ in ["^", "v"]:
        if i%2==0:
            ys += (1 if _=="^" else -1)
        else:
            yr += (1 if _=="^" else -1)
    if _ in [">", "<"]:
        if i%2==0:
            xs += (1 if _==">" else -1)
        else:
            xr += (1 if _==">" else -1)
    coordinates_b.append((xs,ys) if i%2==0 else (xr, yr))
puzzle.answer_b = len(set(coordinates_b))
