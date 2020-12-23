#---------------------------------------------
# Author:       Elaine Lin
# Created Date: 2020-12-19
# References Used: 
#   https://stackoverflow.com/questions/12595051/check-if-string-matches-pattern
#   https://stackoverflow.com/questions/3658145/what-is-the-regex-to-match-an-alphanumeric-6-character-string
#   https://stackoverflow.com/questions/8075877/converting-string-to-int-using-try-except-in-python
#---------------------------------------------

import re
from pathlib import Path

base_path = Path(__file__).parent.parent
file_path = (base_path / '../inputs/Day_4.txt').resolve()

aoc_input = ''

with open(file_path) as file:
    aoc_input = file.read()

aoc_input = aoc_input.split('\n')

attributes = ['byr', 'iyr', 'eyr', 'hgt', 'hcl', 'ecl', 'pid'] #'cid' is optional

#---------------------------------------------
# Part 1
#---------------------------------------------
count_attributes = 0
count_valid = 0

for i in aoc_input:
    if i == "":
        count_valid += 1 if count_attributes == len(attributes) else 0
        count_attributes = 0
    else:
        for j in i.split():
            count_attributes += 1 if (j[:j.index(':')]) in attributes else 0
  
#Checking last passport (last passport will not have newline and therefore would not hit the 'if i == ""' logic above)  
count_valid += 1 if count_attributes == len(attributes) else 0
count_attributes = 0    

print ('Part 1 Answer:', count_valid)            
    
#---------------------------------------------
# Part 2
#---------------------------------------------
count_attributes = 0
count_valid = 0

for i in aoc_input:
    if i == "":
        count_valid += 1 if count_attributes == len(attributes) else 0
        count_attributes = 0
    else:
        for j in i.split():
            attr, value = j.split(':')
            if attr in attributes:
                if attr == 'byr':
                    count_attributes += 1 if 1920 <= int(value) <= 2002 else 0
                elif attr == 'iyr':
                    count_attributes += 1 if 2010 <= int(value) <= 2020 else 0
                elif attr == 'eyr':
                    count_attributes += 1 if 2020 <= int(value) <= 2030 else 0
                elif attr == 'hgt':
                    try:
                        num = int(value[:-2])
                        measure = value[-2:]
                        count_attributes += 1 if (measure=='cm' and 150 <= num <= 193) or (measure=='in' and 59 <= num <= 76) else 0
                    except ValueError:
                        pass
                elif attr == 'hcl':
                    colorcode = value[1:]
                    pattern = re.compile('^[a-f0-9]{6}$')
                    count_attributes += 1 if value[0]=='#' and pattern.match(colorcode) is not None else 0
                elif attr == 'ecl':
                    count_attributes += 1 if value in ['amb', 'blu', 'brn', 'gry', 'grn', 'hzl', 'oth'] else 0
                elif attr == 'pid':
                    count_attributes += 1 if len(value)==9 else 0
  
#Checking last passport (last passport will not have newline and therefore would not hit the 'if i == ""' logic above)  
count_valid += 1 if count_attributes == len(attributes) else 0
count_attributes = 0    

print ('Part 2 Answer:', count_valid)            
