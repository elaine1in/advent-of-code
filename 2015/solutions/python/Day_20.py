#---------------------------------------------
# Author:       Elaine Lin
# Created Date: 2021-03-30
# References Used:
#   https://www.reddit.com/r/adventofcode/comments/3xjpp2/day_20_solutions/
#---------------------------------------------

import math

aoc_input = 34000000

answer_1, answer_2 = None, None
counter = 0

def get_divisors(n):
    small_divisors = [i for i in range(1, int(math.sqrt(n))+1) if n%i==0]
    large_divisors = [int(n/i) for i in small_divisors if n!=(i**2)]
    return (small_divisors+large_divisors)

while not answer_1 or not answer_2:
    counter += 1
    divisors = get_divisors(counter)
    if not answer_1:
        if sum(divisors)*10 >= aoc_input:
            answer_1 = counter
    if not answer_2:
        if sum([i for i in divisors if counter/i<=50])*11 >= aoc_input:
            answer_2 = counter

#---------------------------------------------
# Part 1
#---------------------------------------------
print ('Part 1 Answer:', answer_1)

#---------------------------------------------
# Part 2
#---------------------------------------------
print ('Part 2 Answer:', answer_2)
