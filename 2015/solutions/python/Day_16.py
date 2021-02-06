#---------------------------------------------
# Author:       Elaine Lin
# Created Date: 2021-02-06
# References Used:
#---------------------------------------------

import os
from pathlib import Path
from collections import defaultdict

file_name = ((os.path.basename(__file__)).split('.')[0])
base_path = Path(__file__).parent.parent
file_path = (base_path / '../inputs/{0}.txt'.format(file_name)).resolve()

aoc_input = defaultdict(dict)

with open(file_path) as file:
    for line in file:
        delimiter = line.index(': ')
        k = line[:delimiter]
        v = line[delimiter+2:]
        v_dictionary = defaultdict(int)
        for prop in v.strip().split(', '):
            pk, pv = prop.split(': ')
            v_dictionary[pk] = int(pv)
        aoc_input[k] = v_dictionary
		
MFCSAM = {
            'children': 3
            ,'cats': 7
            ,'samoyeds': 2
            ,'pomeranians': 3
            ,'akitas': 0
            ,'vizslas': 0
            ,'goldfish': 5
            ,'trees': 3
            ,'cars': 2
            ,'perfumes': 1
            }

#---------------------------------------------
# Part 1
#---------------------------------------------
answer = None
for k, v in aoc_input.items():
    if all([cv==MFCSAM[ck] for ck, cv in v.items()]):
        answer = k

print ('Part 1 Answer:', answer)

#---------------------------------------------
# Part 2
#---------------------------------------------
answer = None
gtl = ['cats', 'trees']
ltl = ['pomeranians', 'goldfish']
ol = [k for k, v in MFCSAM.items() if k not in gtl and k not in ltl]

for k, v in aoc_input.items():
    if all([((ck in gtl and cv>MFCSAM[ck]) or (ck in ltl and cv<MFCSAM[ck]) or (ck in ol and cv==MFCSAM[ck])) for ck, cv in v.items()]):
        answer = k

print ('Part 2 Answer:', answer)
