#---------------------------------------------
# Author:       Elaine Lin
# Created Date: 2021-08-21
# References Used:
#   https://stackoverflow.com/questions/8687018/how-to-replace-two-things-at-once-in-a-string
#---------------------------------------------

def solve(fill_length):
    a = '10111011111001111'

    while len(a) < fill_length:
        b = a[::-1].replace('1', '%temp%').replace('0', '1').replace('%temp%', '0')
        a += '0' + b

    check_data = a[:fill_length]
    checksum = ''

    while len(checksum)%2 == 0:
        len_check_data = len(check_data)
        checksum = ''
        for i in range(0, len_check_data, 2):
            pair = check_data[i:i+2]
            checksum += '1' if pair==pair[::-1] else '0'
        check_data = checksum
    
    return checksum

#---------------------------------------------
# Part 1
#---------------------------------------------
answer_1 = solve(272)
print ('Part 1 Answer:', answer_1)

#---------------------------------------------
# Part 2
#---------------------------------------------
answer_2 = solve(35651584)
print ('Part 2 Answer:', answer_2)
