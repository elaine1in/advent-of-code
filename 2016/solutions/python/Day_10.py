#---------------------------------------------
# Author:       Elaine Lin
# Created Date: 2021-04-17
# References Used:
#---------------------------------------------

from collections import defaultdict
import re
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
# aoc_input = """value 5 goes to bot 2
# bot 2 gives low to bot 1 and high to bot 0
# value 3 goes to bot 1
# bot 1 gives low to output 1 and high to bot 0
# bot 0 gives low to output 2 and high to output 0
# value 2 goes to bot 2"""

# aoc_input = aoc_input.split('\n')

bots = defaultdict(list)
outputs = defaultdict(int)

def init():
    for line in aoc_input:
        str_1 = re.match(r'value ([0-9]{1,3}) goes to bot ([0-9]{1,3})', line)

        if str_1:
            value, bot = str_1.groups()
            value = int(value)
            bot = int(bot)
            bots[bot].append(value)

def solve(value_1, value_2, part):
    while True:
        for line in aoc_input:
            str_2 = re.match(r'bot ([0-9]{1,3}) gives low to (bot|output) ([0-9]{1,3}) and high to (bot|output) ([0-9]{1,3})', line)

            if str_2:
                bot, low_bo, low_bo_num, high_bo, high_bo_num = str_2.groups()
                bot = int(bot)
                low_bo_num = int(low_bo_num)
                high_bo_num = int(high_bo_num)

                if len(bots[bot])==2:
                    low = min(bots[bot])
                    high = max(bots[bot])

                    if low_bo=='bot' and low not in bots[low_bo_num]:
                            bots[low_bo_num].append(low)
                    elif low_bo=='output' and low_bo_num not in outputs:
                        outputs[low_bo_num] = low

                    if high_bo=='bot' and high not in bots[high_bo_num]:
                        bots[high_bo_num].append(high)
                    elif high_bo=='output' and high_bo_num not in outputs:
                        outputs[high_bo_num] = high

        for k, v in bots.items():
            if value_1 in v and value_2 in v:
                if part==1:
                    return (k)
                if part==2 and 0 in outputs and 1 in outputs and 2 in outputs:
                    return (outputs[0]*outputs[1]*outputs[2])
        
#---------------------------------------------
# Part 1
#---------------------------------------------
init()
answer_1 = solve(61, 17, 1)

print ('Part 1 Answer:', answer_1)

#---------------------------------------------
# Part 2
#---------------------------------------------
answer_2 = solve(61, 17, 2)

print ('Part 2 Answer:', answer_2)
