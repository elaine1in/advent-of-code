#---------------------------------------------
# Author:       Elaine Lin
# Created Date: 2021-01-15
# References Used:
#   https://realpython.com/python-eval-function/
#   https://stackoverflow.com/questions/18886596/replace-all-quotes-in-a-string-with-escaped-quotes
#   https://stackoverflow.com/questions/4152963/get-name-of-current-script-in-python
#---------------------------------------------

import json
import os
from pathlib import Path

file_name = ((os.path.basename(__file__)).split('.')[0])
base_path = Path(__file__).parent.parent
file_path = (base_path / '../inputs/{0}.txt'.format(file_name)).resolve()

aoc_input = []

with open(file_path) as file:
    for line in file:
        aoc_input.append(line.strip())

#---------------------------------------------
# Part 1
#---------------------------------------------
answer = sum([len(line)-len(eval(line)) for line in aoc_input])
print ('Part 1 Answer:', answer)

#---------------------------------------------
# Part 2
#---------------------------------------------
answer = sum([len(json.dumps(line))-len(line) for line in aoc_input])
print ('Part 2 Answer:', answer)
