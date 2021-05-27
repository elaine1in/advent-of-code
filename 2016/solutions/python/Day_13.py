#---------------------------------------------
# Author:       Elaine Lin
# Created Date: 2021-05-26
# References Used:
#   https://stackoverflow.com/questions/1523465/binary-numbers-in-python
#   https://likegeeks.com/numpy-array-tutorial/#Add_array_element
#---------------------------------------------

import numpy as np

aoc_input = 1352

def wall_openspace(x, y, aoc_input):
    v = (x*x) + (3*x) + (2*x*y) + (y) + (y*y) + (aoc_input)
    b = bin(v)
    ones = b.count('1')

    return ('#' if ones%2==1 else '.')

arr = []

for y in range(100):
    row = []
    for x in range(100):
        row.append(wall_openspace(x, y, aoc_input))
    arr.append(row)

arr = np.array(arr)

def dfs(r, c, arr, ct, part):
    if (part==1 and r==y and c==x) or (part==2 and ct==(50+1)): # In part 2, I am doing (50+1) to offset the ct += 1 taken at coordinate (1, 1)
        steps.append(ct)
        return
    if r<0 or r>=len(arr) or c<0 or c>=len(arr[0]) or arr[r][c]=='#':
        return
    ct += 1
    if part==2: coordinates.append((r, c))
    arr[r][c] = '#'
    m = dfs(r+1, c, arr, ct, part) or dfs(r-1, c, arr, ct, part) or dfs(r, c+1, arr, ct, part) or dfs(r, c-1, arr, ct, part)
    arr[r][c] = '.'
    return m

#---------------------------------------------
# Part 1
#---------------------------------------------
steps = []
x = 31
y = 39
dfs(1, 1, arr, 0, 1)
answer_1 = min(steps)

print ('Part 1 Answer:', answer_1)

#---------------------------------------------
# Part 2
#---------------------------------------------
coordinates = []
dfs(1, 1, arr, 0, 2)
answer_2 = len(set(coordinates))

print ('Part 2 Answer:', answer_2)
