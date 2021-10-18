#---------------------------------------------
# Author:       Elaine Lin
# Created Date: 2021-10-18
# References Used:
# (Part 2) https://stackoverflow.com/questions/34443946/count-consecutive-characters
# (Part 2) https://stackoverflow.com/questions/36441521/find-maximum-length-of-consecutive-repeated-numbers-in-a-list
#---------------------------------------------

from itertools import groupby

def solve(puzzle_input_begin, puzzle_input_end, part):
    answer = 0
    for password in range(puzzle_input_begin, puzzle_input_end+1):
        password = str(password)

        increase = all(password[i]>=password[i-1] for i in range(1, len(password)))

        count_adjacent = 0
        result = [(label, len(list(group))) for label, group in groupby(password)]
        for i in result:
            #i[1] == len(group)
            if part==1 and i[1]>=2:
                count_adjacent += 1
            if part==2 and i[1]==2:
                count_adjacent += 1

        if increase and count_adjacent>0:
            answer += 1

    return answer

puzzle_input_begin = 372037
puzzle_input_end = 905157

#---------------------------------------------
# Part 1
#---------------------------------------------
answer_1 = solve(puzzle_input_begin, puzzle_input_end, 1)

print ('Part 1 Answer:', answer_1)

#---------------------------------------------
# Part 2
#---------------------------------------------
answer_2 = solve(puzzle_input_begin, puzzle_input_end, 2)

print ('Part 2 Answer:', answer_2)
