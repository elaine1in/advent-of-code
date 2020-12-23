#---------------------------------------------
# Author:       Elaine Lin
# Created Date: 2020-12-20
# References Used: 
#   https://www.python-course.eu/recursive_functions.php
#---------------------------------------------

import math
from pathlib import Path

base_path = Path(__file__).parent.parent
file_path = (base_path / '../inputs/Day_5.txt').resolve()

aoc_input = []

with open(file_path) as file:
    for line in file:
        aoc_input.append(line.strip())
        
def binary_space_partitioning(first_row, last_row, index, iterations, bsp):
    if index == (iterations-1):
        return (first_row if bsp[index] in ['F', 'L'] else last_row)
    else:
        #print ('Intermediate at Index', index, ':', first_row if bsp[index] in ['F', 'L'] else math.ceil((last_row+first_row)/2), math.floor((last_row+first_row)/2) if bsp[index] in ['F', 'L'] else last_row, index+1, iterations, bsp)
        return (binary_space_partitioning(first_row if bsp[index] in ['F', 'L'] else math.ceil((last_row+first_row)/2), math.floor((last_row+first_row)/2) if bsp[index] in ['F', 'L'] else last_row, index+1, iterations, bsp))
    
if __name__ == '__main__':
    #---------------------------------------------
    # Test Scenario
    #---------------------------------------------
    #bsp = 'FBFBBFFRLR'
    #row = binary_space_partitioning(0, 127, 0, 7, bsp)
    #column = binary_space_partitioning(0, 7, 7, 10, bsp)
    #print ('Row: {0}, Column: {1}, Seat ID: {2}'.format(row, column, (row*8)+column))
    
    #---------------------------------------------
    # Part 1
    #---------------------------------------------
    seat_ids = []
    
    for bsp in aoc_input:
        row = binary_space_partitioning(0, 127, 0, 7, bsp)
        column = binary_space_partitioning(0, 7, 7, 10, bsp)
        seat_ids.append((row*8)+column)
        
    max_seat_id = max(seat_ids)
    print ('Part 1 Answer:', max_seat_id)
    
    #---------------------------------------------
    # Part 2
    #---------------------------------------------
    missing_seat_id = None
    
    seat_ids = sorted(seat_ids)
    for i in range(1, len(seat_ids)):
        if seat_ids[i]-seat_ids[i-1] != 1:
            missing_seat_id = int((seat_ids[i]+seat_ids[i-1])/2)
            break
            
    print ('Part 2 Answer:', missing_seat_id)
    
    