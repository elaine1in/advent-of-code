#---------------------------------------------
# Author:       Elaine Lin
# Created Date: 2021-01-06
# References Used:
#---------------------------------------------

from pathlib import Path

base_path = Path(__file__).parent.parent
file_path = (base_path / '../inputs/Day_02.txt').resolve()

aoc_input = []

with open(file_path) as file:
    for line in file:
        aoc_input.append(line)

#---------------------------------------------
# Part 1
#---------------------------------------------
answer = 0
for i in aoc_input:
    l, w, h = i.split('x')
    l = int(l)
    w = int(w)
    h = int(h)
    lw = (l*w)
    wh = (w*h)
    hl = (h*l)
    slack = min(lw, wh, hl)
    answer += (2*(lw+wh+hl))+slack

print ('Part 1 Answer:', answer)

#---------------------------------------------
# Part 2
#---------------------------------------------
answer = 0
for i in aoc_input:
    l, w, h = i.split('x')
    l = int(l)
    w = int(w)
    h = int(h)
    sides = sorted([l, w, h])
    answer += (2*(sides[0]+sides[1])) + (l*w*h)

print ('Part 2 Answer:', answer)
