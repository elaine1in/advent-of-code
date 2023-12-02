import os
from pathlib import Path

file_name = ((os.path.basename(__file__)).split('.')[0])
base_path = Path(__file__).parent.parent
file_path = (base_path / '../inputs/{0}.txt'.format(file_name)).resolve()


with open(file_path) as file:
    raw_input = file.read().splitlines()

# raw_input = ["two1nine"
# ,"eightwothree"
# ,"abcone2threexyz"
# ,"xtwone3four"
# ,"4nineeightseven2"
# ,"zoneight234"
# ,"7pqrstsixteen"]
    
def solve(raw_input: list, part: int) -> int:
    if part == 1:
        return sum([int(list(filter(str.isdigit, line))[0] + list(filter(str.isdigit, line))[-1]) for line in raw_input])
    elif part == 2:
        digits = {"one": "1", "two": "2", "three": "3", "four": "4", "five": "5", "six": "6", "seven": "7", "eight": "8", "nine": "9"}
        answer = 0
        for line in raw_input:
            first_digit = None
            last_digit = None
            for i in range(len(line)+1):
                # forward-checking
                if not (first_digit and len(first_digit) == 1):
                    if any(digit in line[:i] for digit in digits.keys()) or list(filter(str.isdigit, line[:i])) != []:
                        if any(digit in line[:i] for digit in digits.keys()):
                            first_digit = "".join([v for k,v in digits.items() if k in line[:i]])
                        elif list(filter(str.isdigit, line[:i])) != []:
                            first_digit = list(filter(str.isdigit, line[:i]))[0]
                        # print (f"{first_digit = }")
                        # print (line[:i])
                # back-tracking
                if not (last_digit and len(last_digit) == 1):
                    if any(digit in line[-i-1:] for digit in digits.keys()) or list(filter(str.isdigit, line[-i-1:])) != []:
                        if any(digit in line[-i-1:] for digit in digits.keys()):
                            last_digit = "".join([v for k,v in digits.items() if k in line[-i-1:]])
                        elif list(filter(str.isdigit, line[-i-1:])) != []:
                            last_digit = list(filter(str.isdigit, line[-i-1:]))[-1]
                        # print (f"{last_digit = }")
                        # print (line[-i-1:])

            if first_digit and last_digit:
                answer += int(first_digit+last_digit)

        return answer

print (f"answer: {solve(raw_input=raw_input, part=1)}")
print (f"answer: {solve(raw_input=raw_input, part=2)}")
