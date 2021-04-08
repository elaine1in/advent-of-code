#---------------------------------------------
# Author:       Elaine Lin
# Created Date: 2021-04-06
# References Used: (Adapted from Advent of Code 2015 Day 4)
#   https://stackoverflow.com/questions/5297448/how-to-get-md5-sum-of-a-string-using-python
#---------------------------------------------

from collections import defaultdict
import hashlib

aoc_input = 'ojvtpuvg'

def solve(num, part):
    password = ''
    password_dictionary = defaultdict(str)
    counter = 0
    while (part==1 and len(password)!=8) or (part==2 and len(password_dictionary)!=8):
        counter += 1
        s = '{0}{1}'.format(aoc_input, counter)
        hexdigest = hashlib.md5(s.encode('utf-8')).hexdigest()
        if hexdigest[:num] == '0'*num:
            password += hexdigest[num]
            try:
                i = int(hexdigest[num])
                if i<8 and i not in password_dictionary:
                    password_dictionary[i] = hexdigest[num+1]
            except:
                pass
    return (password) if part==1 else (password_dictionary)

#---------------------------------------------
# Part 1
#---------------------------------------------
answer_1 = solve(5, 1)
    
print ('Part 1 Answer:', answer_1)

#---------------------------------------------
# Part 2
#---------------------------------------------
answer_2 = ['.', '.', '.', '.', '.', '.', '.', '.']
pd = solve(5, 2)
for k, v in pd.items():
    answer_2[k] = v
answer_2 = ''.join(answer_2)

print ('Part 2 Answer:', answer_2)
