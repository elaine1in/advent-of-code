#---------------------------------------------
# Author:       Elaine Lin
# Created Date: 2021-01-19
# References Used:
#   https://stackoverflow.com/questions/10851906/python-3-unboundlocalerror-local-variable-referenced-before-assignment
#---------------------------------------------

aoc_input = '1321131112'
aoc_input += 'z'

l = []

def solve_look_and_say(aoc_input, iterations):
    for i in range(iterations):
        aoc_input = aoc_input if i==0 else (''.join(str(i) for i in l) + 'z')
        l = []
        count_same = 0
        for x in range(len(aoc_input)-1):
            if aoc_input[x] != aoc_input[x+1]:
                l.append(count_same+1)
                l.append(int(aoc_input[x]))
                count_same = 0
            else:
                count_same += 1
    return (l)

if __name__ == '__main__':
    #---------------------------------------------
    # Part 1
    #---------------------------------------------
    answer = len(solve_look_and_say(aoc_input, 40))
    print ('Part 1 Answer:', answer)

    #---------------------------------------------
    # Part 2
    #---------------------------------------------
    answer = len(solve_look_and_say(aoc_input, 50))
    print ('Part 2 Answer:', answer)
