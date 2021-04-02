#---------------------------------------------
# Author:       Elaine Lin
# Created Date: 2021-04-01
# References Used:
#   https://regexone.com/references/python
#---------------------------------------------

import re
from itertools import permutations
from collections import defaultdict
import os
from pathlib import Path

file_name = ((os.path.basename(__file__)).split('.')[0])
base_path = Path(__file__).parent.parent
file_path = (base_path / '../inputs/{0}.txt'.format(file_name)).resolve()

aoc_input = None

with open(file_path) as file:
    aoc_input = [line.strip() for line in file]

#---------------------------------------------
# Test Scenario
#---------------------------------------------
# test = """Alice would gain 54 happiness units by sitting next to Bob.
# Alice would lose 79 happiness units by sitting next to Carol.
# Alice would lose 2 happiness units by sitting next to David.
# Bob would gain 83 happiness units by sitting next to Alice.
# Bob would lose 7 happiness units by sitting next to Carol.
# Bob would lose 63 happiness units by sitting next to David.
# Carol would lose 62 happiness units by sitting next to Alice.
# Carol would gain 60 happiness units by sitting next to Bob.
# Carol would gain 55 happiness units by sitting next to David.
# David would gain 46 happiness units by sitting next to Alice.
# David would lose 7 happiness units by sitting next to Bob.
# David would gain 41 happiness units by sitting next to Carol."""

# aoc_input = [line for line in test.split('\n')]

people = defaultdict(dict)

for line in aoc_input:
    pattern = '([A-Za-z]{1,10}) would (lose|gain) ([0-9]{1,3}) happiness units by sitting next to ([A-Za-z]{1,10})'
    match = re.search(pattern, line)

    person_1 = match.group(1)
    lg = match.group(2)
    value = match.group(3)
    person_2 = match.group(4)

    people[person_1][person_2] = int(value)*(-1 if lg=='lose' else 1)

def solve(p):
    happiness = []
    for seating in permutations(p):
        score = 0
        for i, person in enumerate(seating):
            p1 = seating[i]
            p2 = seating[i+1 if i!=len(seating)-1 else 0]

            score += people[p1][p2] + people[p2][p1]
        happiness.append(score)
    return (max(happiness))

#---------------------------------------------
# Part 1
#---------------------------------------------
p = [k for k, v in people.items()]
answer_1 = solve(p)

print ('Part 1 Answer:', answer_1)

#---------------------------------------------
# Part 2
#---------------------------------------------
n = 'Me'
p = [k for k, v in people.items()]
# Adding myself to the dictionary
for k in p:
    people[k][n] = 0
    people[n][k] = 0
# Resetting p to include myself
p = [k for k, v in people.items()]

answer_2 = solve(p)

print ('Part 2 Answer:', answer_2)
