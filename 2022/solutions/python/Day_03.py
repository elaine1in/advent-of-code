#---------------------------------------------
# Author:       Elaine Lin
# Created Date: 2022-12-03
# References Used:
#   https://stackoverflow.com/questions/48611525/find-common-characters-between-two-strings
#   https://stackoverflow.com/questions/20625579/access-the-sole-element-of-a-set
#   https://stackoverflow.com/questions/227459/how-to-get-the-ascii-value-of-a-character
#---------------------------------------------

import os
from pathlib import Path

file_name = ((os.path.basename(__file__)).split('.')[0])
base_path = Path(__file__).parent.parent
file_path = (base_path / '../inputs/{0}.txt'.format(file_name)).resolve()

aoc_input = []

with open(file_path) as file:
    aoc_input = [line.strip() for line in file]

#---------------------------------------------
# Test Scenario
#---------------------------------------------
# aoc_input = """vJrwpWtwJgWrhcsFMMfFFhFp
# jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
# PmmdzqPrVvPwwTWBwg
# wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
# ttgJtRGJQctTZtZT
# CrZsJsPPZsGzwwsLwLmpwMDw"""
# aoc_input = aoc_input.split('\n')

def solve(part: int) -> int:
    total = 0
    group = []
    for i, rucksack in enumerate(aoc_input):
        if part == 1:
            midpoint = len(rucksack)//2
            compartment_one = rucksack[:midpoint]
            compartment_two = rucksack[midpoint:]
            intersection = set(compartment_one) & set(compartment_two)
        if part == 2:
            if i>0 and i%3==0:
                group = []
            group.append(rucksack)
            intersection = set()
            if len(group) == 3:
                compartment_one, compartment_two, compartment_three = group
                intersection = set(compartment_one) & set(compartment_two) & set(compartment_three)
        duplicate = intersection.pop() if intersection else None
        if duplicate:
            offset = 96 if 97<=ord(duplicate)<=122 else 38
            total += (ord(duplicate)-offset)
    return total

#---------------------------------------------
# Part 1
#---------------------------------------------
answer_1 = solve(part=1)

print ('Part 1 Answer:', answer_1)

#---------------------------------------------
# Part 2
#---------------------------------------------
answer_2 = solve(part=2)

print ('Part 2 Answer:', answer_2)
