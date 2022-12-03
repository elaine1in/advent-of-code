#---------------------------------------------
# Author:       Elaine Lin
# Created Date: 2022-12-03
# References Used:
#---------------------------------------------

import os
from pathlib import Path

file_name = ((os.path.basename(__file__)).split('.')[0])
base_path = Path(__file__).parent.parent
file_path = (base_path / '../inputs/{0}.txt'.format(file_name)).resolve()

aoc_input = []

with open(file_path) as file:
    aoc_input = [line.strip() for line in file]

#---------------------------------------------
# Test Scenario
#---------------------------------------------
# aoc_input = ['A Y', 'B X', 'C Z']

rps = {
        'rock': ['A', 'X']
        ,'paper': ['B', 'Y']
        ,'scissors': ['C', 'Z']
        }
# opponent: me (do I win or lose?)
rps_wl = {
            'rock': {'rock': 'draw', 'paper': 'win', 'scissors': 'lose'}
            ,'paper': {'paper': 'draw', 'rock': 'lose', 'scissors': 'win'}
            ,'scissors': {'scissors': 'draw', 'paper': 'lose', 'rock': 'win'}
        }
# how do I need to end the round?
rps_map = {'X': 'lose', 'Y': 'draw', 'Z': 'win'}

def solve(part: int) -> int:
    total_points = []
    for round in aoc_input:
        points = 0
        opponent, N = round.split()

        for k, v in rps.items():
            if opponent in v:
                o_rps = k
            if part==1 and N in v:
                m_rps = k

        if part==2:
            for k, v in rps_wl[o_rps].items():
                if rps_map[N]==v:
                    m_rps = k

        # print (f"opponent pick: {o_rps} // my pick: {m_rps}")

        # points for shape I selected
        if m_rps=='rock':
            points += 1
        elif m_rps=='paper':
            points += 2
        elif m_rps=='scissors':
            points += 3
        
        # points for outcome of the round
        win_lose = rps_wl[o_rps][m_rps]
        if win_lose=='win':
            points += 6
        elif win_lose=='draw':
            points += 3
        elif win_lose=='lose':
            points += 0
        
        total_points.append(points)
    return sum(total_points)

#---------------------------------------------
# Part 1
#---------------------------------------------
answer_1 = solve(part=1)

print ('Part 1 Answer:', answer_1)

#---------------------------------------------
# Part 2
#---------------------------------------------
answer_2 = solve(part=2)

print ('Part 2 Answer:', answer_2)
