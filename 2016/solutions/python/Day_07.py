#---------------------------------------------
# Author:       Elaine Lin
# Created Date: 2021-03-13
# References Used:
#   https://stackoverflow.com/questions/3697432/how-to-find-list-intersection
#---------------------------------------------

import re
from collections import defaultdict, Counter
import os
from pathlib import Path

file_name = ((os.path.basename(__file__)).split('.')[0])
base_path = Path(__file__).parent.parent
file_path = (base_path / '../inputs/{0}.txt'.format(file_name)).resolve()

aoc_input = None

with open(file_path) as file:
    aoc_input = [line.strip() for line in file]

#aoc_input = ['aba[bab]xyz', 'xyx[xyx]xyx', 'aaa[kek]eke', 'zazbz[bzb]cdb']

ip_addresses_part_1 = defaultdict(dict)
ip_addresses_part_2 = defaultdict(dict)
regexp = re.compile(r'([a-z]+)+')

for line in aoc_input:
    modulo = defaultdict(int)
    chunks = defaultdict(list)
    matches = re.findall(regexp, line)
    # print ('line:', line, 'matches:', matches)

    for i, match in enumerate(matches):
        key = 'even' if i%2==0 else 'odd'

        for x in range(len(match)-3):
            substring = match[x:x+4]
            modulo[key] += 1 if substring==substring[::-1] and len(Counter(substring))==2 else 0
        for x in range(len(match)-2):
            substring = match[x:x+3]
            #if substring matches ABA / BAB pattern, append to list
            if substring[0]==substring[-1] and substring[0]!=substring[1]:
                chunks[key].append(substring)

    ip_addresses_part_1[line] = modulo
    ip_addresses_part_2[line] = chunks

#---------------------------------------------
# Part 1
#---------------------------------------------
answer1 = sum([1 for k, v in ip_addresses_part_1.items() if v['even']>0 and v['odd']==0])

print ('Part 1 Answer:', answer1)

#---------------------------------------------
# Part 2
#---------------------------------------------
answer2 = []

for k, v in ip_addresses_part_2.items():
    for aba in v['even']:
        inverse_aba = aba[1] + aba[0] + aba[1]
        if inverse_aba in v['odd'] and k not in answer2:
            answer2.append(k)

print ('Part 2 Answer:', len(answer2))
