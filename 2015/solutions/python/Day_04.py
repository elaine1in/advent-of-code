#---------------------------------------------
# Author:       Elaine Lin
# Created Date: 2021-01-08
# References Used:
#   https://stackoverflow.com/questions/5297448/how-to-get-md5-sum-of-a-string-using-python
#---------------------------------------------

import hashlib

aoc_input = 'ckczppom'

#---------------------------------------------
# Part 1
#---------------------------------------------
hexdigest = ''
counter = 0

while hexdigest[:5] != '00000':
    s = '{0}{1}'.format(aoc_input, counter)
    hexdigest = hashlib.md5(s.encode('utf-8')).hexdigest()
    counter += 1
    
counter -= 1 #to offset increment from while loop
print ('Part 1 Answer:', counter)

#---------------------------------------------
# Part 2
#---------------------------------------------
hexdigest = ''
counter = 0

while hexdigest[:6] != '000000':
    s = '{0}{1}'.format(aoc_input, counter)
    hexdigest = hashlib.md5(s.encode('utf-8')).hexdigest()
    counter += 1
    
counter -= 1 #to offset increment from while loop
print ('Part 2 Answer:', counter)
