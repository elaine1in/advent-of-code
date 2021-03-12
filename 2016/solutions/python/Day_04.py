#---------------------------------------------
# Author:       Elaine Lin
# Created Date: 2021-03-11
# References Used: 
#   Part 1
#   https://stackoverflow.com/questions/12595051/check-if-string-matches-pattern
#   https://www.guru99.com/python-regular-expressions-complete-tutorial.html#6
#   https://stackoverflow.com/questions/20950650/how-to-sort-counter-by-value-python
#   https://stackoverflow.com/questions/44076269/sort-counter-by-frequency-then-alphabetically-in-python
#   https://stackoverflow.com/questions/42108797/tuple-unpacking-into-function-with-list-comprehension
#   Part 2
#   https://stackoverflow.com/questions/8886947/caesar-cipher-function-in-python
#---------------------------------------------

import re
import string
from collections import Counter
import os
from pathlib import Path

file_name = ((os.path.basename(__file__)).split('.')[0])
base_path = Path(__file__).parent.parent
file_path = (base_path / '../inputs/{0}.txt'.format(file_name)).resolve()

aoc_input = []

with open(file_path) as file:
    aoc_input = [line.strip() for line in file]

regexp = re.compile(r'(([a-z]+-)+)([0-9]+)([[a-z]+])')

def caesar(plaintext, shift):
    alphabet = string.ascii_lowercase
    shifted_alphabet = alphabet[shift%26:] + alphabet[:shift%26]
    table = str.maketrans(alphabet, shifted_alphabet)
    return (plaintext.translate(table))

answer1 = 0
answer2 = 0

for room in aoc_input:
    match = regexp.search(room)
        
    # print ('room:', room)
    # print ('match:', match.groups()) #skip group 2 since I needed nested parenthesis to correctly capture room name

    name = match.group(1).replace('-', '')
    sector_id = int(match.group(3))
    checksum = match.group(4).replace('[', '').replace(']', '')
    # print ('name:', name, 'sector_id:', sector_id, 'checksum:', checksum)

    counter = Counter(sorted(name)).most_common()
    letters_counter = [k for k, v in counter]
    order = [letter for letter in letters_counter if letter in checksum]

    answer1 += sector_id if checksum==''.join(order) else 0

    if 'northpole' in caesar(name, sector_id):
        answer2 = sector_id

#---------------------------------------------
# Part 1
#---------------------------------------------
print ('Part 1 Answer:', answer1)

#---------------------------------------------
# Part 2
#---------------------------------------------
print ('Part 2 Answer:', answer2)
