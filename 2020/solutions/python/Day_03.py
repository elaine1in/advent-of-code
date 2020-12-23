#---------------------------------------------
# Author:       Elaine Lin
# Created Date: 2020-12-19
# References Used: 
#   https://stackoverflow.com/questions/34846413/find-how-many-lines-in-string
#   https://stackoverflow.com/questions/18682965/python-remove-last-line-from-string
#---------------------------------------------

import math
from pathlib import Path

base_path = Path(__file__).parent.parent
file_path = (base_path / '../inputs/Day_03.txt').resolve()

aoc_input = ''

with open(file_path) as file:
    aoc_input = file.read()
      
#---------------------------------------------
# Part 1
#---------------------------------------------
lines = (aoc_input.count('\n'))+1

new_map = ""
for i in (aoc_input.split('\n')):
    new_map += (i.strip()*lines) + '\n'
    
#Removing last '\n'
new_map = new_map[:new_map.rfind('\n')]
#Make new_map into a list
new_map = new_map.split('\n')

count_trees = 0
for i in range(len(new_map)):
    if i==0:
        pass
    else:
        count_trees += 1 if new_map[i][i*3]=='#' else 0
    
print ('Part 1 Answer:', count_trees)

#---------------------------------------------
# Part 2
#---------------------------------------------
#Slopes: Right 1, Down 1 // Right 3, Down 1 // Right 5, Down 1 // Right 7, Down 1
slopes = [1, 3, 5, 7]
slopes_trees = []

for x in slopes:
    count_trees = 0
    for i in range(len(new_map)):
        if i==0:
            pass
        else:
            count_trees += 1 if new_map[i][i*x]=='#' else 0
    slopes_trees.append(count_trees)
    
#Slope: Right 1, Down 2
count_trees = 0
for i in range(len(new_map)):
    if i==0 or i%2==1:
        pass
    else:
        count_trees += 1 if new_map[i][int(i/2)]=='#' else 0
slopes_trees.append(count_trees)

print ('Part 2 Answer:', math.prod(slopes_trees))
