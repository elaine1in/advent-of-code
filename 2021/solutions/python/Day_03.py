#---------------------------------------------
# Author:       Elaine Lin
# Created Date: 2021-12-02
# References Used:
#   https://www.geeksforgeeks.org/python-vertical-grouping-value-lists/
#   https://stackoverflow.com/questions/268272/getting-key-with-maximum-value-in-dictionary
#   https://www.geeksforgeeks.org/lambda-filter-python-examples/
#---------------------------------------------

from collections import Counter
import os
from pathlib import Path

file_name = ((os.path.basename(__file__)).split('.')[0])
base_path = Path(__file__).parent.parent
file_path = (base_path / '../inputs/{0}.txt'.format(file_name)).resolve()

aoc_input = [i for i in open(file_path).read().split('\n')]

#---------------------------------------------
# Test Scenario
#---------------------------------------------
# aoc_input = ['00100','11110','10110','10111','10101','01111','00111','11100','10000','11001','00010','01010']

#---------------------------------------------
# Part 1
#---------------------------------------------
verticals = [''.join(list(i)) for i in zip(*aoc_input)]

gamma_rate = ''
epsilon_rate = ''

for bits in verticals:
    c = Counter(bits)
    gr = max(c, key=c.get)
    er = min(c, key=c.get)

    gamma_rate += gr
    epsilon_rate += er

answer_1 = int(gamma_rate, 2)*int(epsilon_rate, 2)

print ('Part 1 Answer:', answer_1)

#---------------------------------------------
# Part 2
#---------------------------------------------
def solve(l: list, t: str):
    index = 0
    while len(l)>1:
        verticals = [''.join(list(i)) for i in zip(*l)]
        c = Counter(verticals[index])
        gr = max(c, key=c.get)
        er = min(c, key=c.get)
        #override if 0 and 1 equally common (tie)
        if len(l)==2 and len(c)==2:
            gr='1'
            er='0'
        #determine value to pass into lambda below
        value = gr if t=='oxy' else er
        #filter list based on value at index
        l = list(filter(lambda x: x[index]==value, l))
        index += 1

    return ''.join(l)

answer_2 = int(solve(aoc_input, 'oxy'), 2)*int(solve(aoc_input, 'co2'), 2)
    
print ('Part 2 Answer:', answer_2)
