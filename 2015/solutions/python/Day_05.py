#---------------------------------------------
# Author:       Elaine Lin
# Created Date: 2021-01-09
# References Used:
#---------------------------------------------

from pathlib import Path

base_path = Path(__file__).parent.parent
file_path = (base_path / '../inputs/Day_05.txt').resolve()

aoc_input = []

with open(file_path) as file:
    for line in file:
        aoc_input.append(line.strip())

#---------------------------------------------
# Part 1
#---------------------------------------------
answer = 0
vowels = ['a', 'e', 'i', 'o', 'u']
disallowed = ['ab', 'cd', 'pq', 'xy']
for string in aoc_input:
    if any(i in string for i in disallowed):
        continue
    else:
        count_vowels = sum([string.count(x) for x in vowels])
        count_double = sum([1 if string[i]==string[i+1] else 0 for i in range(len(string)-1)])
        answer += 1 if (count_vowels>=3) and (count_double>0) else 0

print ('Part 1 Answer:', answer)

#---------------------------------------------
# Part 2
#---------------------------------------------
answer = 0
for string in aoc_input:
    count_twice = sum([1 if string.count(string[i:i+2])>=2 else 0 for i in range(len(string)-1)])
    count_letter = sum([1 if string[i]==string[i+2] else 0 for i in range(len(string)-2)])
    answer += 1 if (count_twice>0) and (count_letter>0) else 0

print ('Part 2 Answer:', answer)
