#---------------------------------------------
# Author:       Elaine Lin
# Created Date: 2020-12-19
# References Used:
#   https://www.geeksforgeeks.org/python-count-occurrences-of-a-character-in-string/
#   https://stackoverflow.com/questions/13628791/determine-whether-integer-is-between-two-other-integers

#   https://stackoverflow.com/questions/32753157/python-conditional-one-or-the-other-but-not-both
#---------------------------------------------

from pathlib import Path

base_path = Path(__file__).parent.parent
file_path = (base_path / '../inputs/Day_02.txt').resolve()

aoc_input = []

with open(file_path) as file:
    for line in file:
        aoc_input.append(line)

#---------------------------------------------
# Part 1
#---------------------------------------------
count_valid = 0

for i in aoc_input:
    rule, word = i.split(':')
    word = word.strip()
    number, letter = rule.split(' ')
    letter = letter.strip()
    min, max = number.split('-')
    min = int(min)
    max = int(max)
    
    count_valid += 1 if min <= (word.count(letter)) <= max else 0
    
print ('Part 1 Answer:', count_valid)
    
#---------------------------------------------
# Part 2
#---------------------------------------------
count_valid = 0

for i in aoc_input:
    rule, word = i.split(':')
    word = word.strip()
    number, letter = rule.split(' ')
    letter = letter.strip()
    position1, position2 = number.split('-')
    position1 = int(position1)-1
    position2 = int(position2)-1
    
    count_valid += 1 if (word[position1]==letter) != (word[position2]==letter) else 0

print ('Part 2 Answer:', count_valid)
