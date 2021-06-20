#---------------------------------------------
# Author:       Elaine Lin
# Created Date: 2021-04-08
# References Used:
#---------------------------------------------

from collections import defaultdict
import os
from pathlib import Path

file_name = ((os.path.basename(__file__)).split('.')[0])
base_path = Path(__file__).parent.parent
file_path = (base_path / '../inputs/{0}.txt'.format(file_name)).resolve()

aoc_input = []

with open(file_path) as file:
    for line in file:
        line = [int(i) for i in line.strip().split('\t')]
        aoc_input.append(line)
      
#---------------------------------------------
# Test Scenario
#---------------------------------------------  
# Part 1
# aoc_input = [[5, 1, 9, 5]
#             ,[7, 5, 3]
#             ,[2, 4, 6, 8]]

# Part 2
# aoc_input = [[5, 9, 2, 8]
#             ,[9, 4, 7, 3]
#             ,[3, 8, 6, 5]]

#---------------------------------------------
# Part 1
#---------------------------------------------
answer_1 = sum([max(aoc_input[i])-min(aoc_input[i]) for i in range(len(aoc_input))])

print ('Part 1 Answer:', answer_1)

#---------------------------------------------
# Part 2
#---------------------------------------------
answer_2 = 0
for ix, line in enumerate(aoc_input):
    divisors = defaultdict(list)
    for num in line:
        divisors[num] = [i for i in range(2, num) if num%i==0] #start from 2 since all numbers will always be divisible by 1

    flatten = [i for l in divisors.values() for i in l]
    small_num = sum([k for k, v in divisors.items() if k in flatten])
    large_num = sum([k for k, v in divisors.items() if small_num in v])
    # print ('ix:', ix, 'large_num:', large_num, 'small_num:', small_num)
    answer_2 += int(large_num/small_num)

print ('Part 2 Answer:', answer_2)
