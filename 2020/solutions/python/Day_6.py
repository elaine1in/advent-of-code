#---------------------------------------------
# Author:       Elaine Lin
# Created Date: 2020-12-20
# References Used: 
#   https://www.geeksforgeeks.org/python-get-unique-values-list/
#   https://stackoverflow.com/questions/57210753/find-common-values-in-multiple-lists
#   https://www.tutorialspoint.com/find-common-elements-in-list-of-lists-in-python
#---------------------------------------------

from pathlib import Path

base_path = Path(__file__).parent
file_path = (base_path / '../inputs/Day_6.txt').resolve()

aoc_input = []

with open(file_path) as file:
    aoc_input = file.read()
		
aoc_input = aoc_input.split('\n')

#---------------------------------------------
# Part 1
#---------------------------------------------
count_total = 0
s = ''

for i in aoc_input:
    if i == "":
        count_total += len(set(s))
        s = ''
    else:
        s += i
        
#Checking last group (last group will not have newline and therefore would not hit the 'if i == ""' logic above)         
count_total += len(set(s))
s = ''
        
print ('Part 1 Answer:', count_total)

#---------------------------------------------
# Part 2
#---------------------------------------------
count_total = 0
s = []

for i in aoc_input:
    if i == "":
        count_total += len(list(set.intersection(*map(set, s))))
        s = []
    else:
        s.append(list(i))

#Checking last group (last group will not have newline and therefore would not hit the 'if i == ""' logic above) 
count_total += len(list(set.intersection(*map(set, s))))
s = []      

print ('Part 2 Answer:', count_total)

