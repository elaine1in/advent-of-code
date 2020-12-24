#---------------------------------------------
# Author:       Elaine Lin
# Created Date: 2020-12-24
# References Used: 
#---------------------------------------------

from pathlib import Path

base_path = Path(__file__).parent.parent
file_path = (base_path / '../inputs/Day_22.txt').resolve()

aoc_input = []

with open(file_path) as file:
    aoc_input = file.read()

#---------------------------------------------
# Test Scenario
#---------------------------------------------
#aoc_input = """Player 1:
#9
#2
#6
#3
#1
#
#Player 2:
#5
#8
#4
#7
#10"""

aoc_input = aoc_input.split('\n')

p1_index = aoc_input.index('Player 1:')
p2_index = aoc_input.index('Player 2:')
n_index = aoc_input.index('')

player_1 = [int(i) for i in aoc_input[p1_index+1:n_index]]
player_2 = [int(i) for i in aoc_input[p2_index+1:]]

#---------------------------------------------
# Part 1
#---------------------------------------------
assert len(player_1)==len(player_2)

while player_1 and player_2:
    p1_card = player_1[0]
    p2_card = player_2[0]
    if p1_card > p2_card:
        player_1.append(p1_card)
        player_1.append(p2_card)
    else:
        player_2.append(p2_card)
        player_2.append(p1_card)
    #remove first element from both lists
    player_1.pop(0)
    player_2.pop(0)

winner = player_1 if player_1 else player_2
length = len(winner)
answer = 0

for i in range(length):
    answer += (winner[i]*(length-i))

print ('Part 1 Answer:', answer)

