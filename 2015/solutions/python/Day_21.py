#---------------------------------------------
# Author:       Elaine Lin
# Created Date: 2021-03-14
# References Used:
#   https://stackoverflow.com/questions/15305719/pick-combinations-from-multiple-lists
#---------------------------------------------

import math
import itertools
import os
from pathlib import Path

file_name = ((os.path.basename(__file__)).split('.')[0])
base_path = Path(__file__).parent.parent
file_path = (base_path / '../inputs/{0}.txt'.format(file_name)).resolve()

aoc_input = None

with open(file_path) as file:
    aoc_input = [line.strip() for line in file]

boss_hp = None
boss_damage = None
boss_armor = None

for stat in aoc_input:
    prop, value = stat.split(': ')
    if prop=='Hit Points':
        boss_hp = int(value)
    elif prop=='Damage':
        boss_damage = int(value)
    elif prop=='Armor':
        boss_armor = int(value)

# print (boss_hp, boss_damage, boss_armor)

weapons = {
            'Dagger': {'cost': 8, 'damage': 4, 'armor': 0}
            ,'Shortsword': {'cost': 10, 'damage': 5, 'armor': 0}
            ,'Warhammer': {'cost': 25, 'damage': 6, 'armor': 0}
            ,'Longsword': {'cost': 40, 'damage': 7, 'armor': 0}
            ,'Greataxe': {'cost': 74, 'damage': 8, 'armor': 0}
            }
armor = {
        'Leather': {'cost': 13, 'damage': 0, 'armor': 1}
        ,'Chainmail': {'cost': 31, 'damage': 0, 'armor': 2}
        ,'Splintmail': {'cost': 53, 'damage': 0, 'armor': 3}
        ,'Bandedmail': {'cost': 75, 'damage': 0, 'armor': 4}
        ,'Platemail': {'cost': 102, 'damage': 0, 'armor': 5}
        }
rings = {
        'Damage +1': {'cost': 25, 'damage': 1, 'armor': 0}
        ,'Damage +2': {'cost': 50, 'damage': 2, 'armor': 0}
        ,'Damage +3': {'cost': 100, 'damage': 3, 'armor': 0}
        ,'Defense +1': {'cost': 20, 'damage': 0, 'armor': 1}
        ,'Defense +2': {'cost': 40, 'damage': 0, 'armor': 2}
        ,'Defense +3': {'cost': 80, 'damage': 0, 'armor': 3}
        }

# weapons (1)
weapon_combos = [tuple([i]) for i in weapons.keys()]

# armor (0-1)
armor_combos = [tuple([i]) for i in armor.keys()]
armor_combos.append(())

# rings (0-2)
ring_combos = [i for i in itertools.combinations(rings, 2)] #all combinations of 2-rings
ring_combos.extend([tuple([i]) for i in rings.keys()]) #1-ring
ring_combos.append(()) #0-ring

# possible combinations of weapons, armor, and rings
battle_combos = [combo for combo in itertools.product(weapon_combos, armor_combos, ring_combos)]

winning_costs = []
losing_costs = []

for combo in battle_combos:
    player_hp = 100
    player_damage = 0
    player_armor = 0
    gold = 0

    for i, item in enumerate(combo):
        for x in item:
            w = weapons.get(x)
            a = armor.get(x)
            r = rings.get(x)

            player_damage += w['damage'] if w is not None else 0
            player_damage += a['damage'] if a is not None else 0
            player_damage += r['damage'] if r is not None else 0
            player_armor += w['armor'] if w is not None else 0
            player_armor += a['armor'] if a is not None else 0
            player_armor += r['armor'] if r is not None else 0

            gold += w['cost'] if w is not None else 0
            gold += a['cost'] if a is not None else 0
            gold += r['cost'] if r is not None else 0

    pd = (player_damage-boss_armor)
    bd = (boss_damage-player_armor)
    player_turns_to_win = math.ceil(boss_hp/(pd if pd>0 else 1))
    boss_turns_to_win = math.ceil(player_hp/(bd if bd>0 else 1))

    if player_turns_to_win <= boss_turns_to_win:
        winning_costs.append(gold)
    if player_turns_to_win > boss_turns_to_win:
        losing_costs.append(gold)

#---------------------------------------------
# Part 1
#---------------------------------------------
answer1 = min(winning_costs)

print ('Part 1 Answer:', answer1)

#---------------------------------------------
# Part 2
#---------------------------------------------
answer2 = max(losing_costs)

print ('Part 2 Answer:', answer2)
