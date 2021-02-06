#---------------------------------------------
# Author:       Elaine Lin
# Created Date: 2021-02-05
# References Used:
#   https://stackoverflow.com/questions/464864/how-to-get-all-possible-combinations-of-a-list-s-elements
#   https://stackoverflow.com/questions/12935194/permutations-between-two-lists
#   https://stackoverflow.com/questions/2600191/how-can-i-count-the-occurrences-of-a-list-item
#---------------------------------------------

import os
from pathlib import Path
from collections import defaultdict, Counter
import itertools

file_name = ((os.path.basename(__file__)).split('.')[0])
base_path = Path(__file__).parent.parent
file_path = (base_path / '../inputs/{0}.txt'.format(file_name)).resolve()

aoc_input = defaultdict(dict)

with open(file_path) as file:
    for line in file:
        k, v = line.split(': ')
        v_dictionary = defaultdict(int)
        for prop in v.strip().split(', '):
            pk, pv = prop.split()
            v_dictionary[pk] = int(pv)
        aoc_input[k] = v_dictionary

nums = [i for i in range(1, 101)]
combos = itertools.combinations(nums, 4)
combos_100 = [i for i in combos if sum(i)==100]
properties = [k for k, v in aoc_input.items()]

all_permutations_valid = []
for i, combo in enumerate(combos_100):
    l_combo = list(combo)
    permutations = list(itertools.product(properties, l_combo))
    all_permutations = itertools.combinations(permutations, 4)
    for j in list(all_permutations):
        p = [k[0] for k in j] #list of properties
        n = [k[1] for k in j] #list of numbers
        if all([v==1 for k, v in Counter(p).items()]) and sum(n)==100:
            all_permutations_valid.append(j)

scores_1 = []
scores_2 = []
for i, permutation in enumerate(all_permutations_valid):
    capacity = sum([j[1]*aoc_input[j[0]]['capacity'] for j in permutation])
    durability = sum([j[1]*aoc_input[j[0]]['durability'] for j in permutation])
    flavor = sum([j[1]*aoc_input[j[0]]['flavor'] for j in permutation])
    texture = sum([j[1]*aoc_input[j[0]]['texture'] for j in permutation])
    calories = sum([j[1]*aoc_input[j[0]]['calories'] for j in permutation])

    score = (capacity*durability*flavor*texture)
    if all([j>0 for j in [capacity, durability, flavor, texture]]):
        scores_1.append(score)
        if calories==500:
            scores_2.append(score)

#---------------------------------------------
# Part 1
#---------------------------------------------
answer = max(scores_1)
print ('Part 1 Answer:', answer)

#---------------------------------------------
# Part 2
#---------------------------------------------
answer = max(scores_2)
print ('Part 2 Answer:', answer)
