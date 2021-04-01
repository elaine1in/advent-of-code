#---------------------------------------------
# Author:       Elaine Lin
# Created Date: 2021-01-08
# References Used:
#   https://stackoverflow.com/questions/5297448/how-to-get-md5-sum-of-a-string-using-python
#---------------------------------------------

import hashlib

aoc_input = 'ckczppom'

def solve(num):
    hexdigest = ''
    counter = 0
    while hexdigest[:num] != '0'*num:
        counter += 1
        s = '{0}{1}'.format(aoc_input, counter)
        hexdigest = hashlib.md5(s.encode('utf-8')).hexdigest()
    return (counter)

#---------------------------------------------
# Part 1
#---------------------------------------------
answer_1 = solve(5)
    
print ('Part 1 Answer:', answer_1)

#---------------------------------------------
# Part 2
#---------------------------------------------
answer_2 = solve(6)

print ('Part 2 Answer:', answer_2)
