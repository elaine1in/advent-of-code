#---------------------------------------------
# Author:       Elaine Lin
# Created Date: 2020-12-20
# References Used: 
#   https://stackoverflow.com/questions/4664850/how-to-find-all-occurrences-of-a-substring
#   https://stackoverflow.com/questions/12199757/python-ternary-operator-without-else
#   https://stackoverflow.com/questions/8177079/take-the-content-of-a-list-and-append-it-to-another-list
#   https://stackoverflow.com/questions/252703/what-is-the-difference-between-pythons-list-methods-append-and-extend
#   https://stackoverflow.com/questions/42438808/finding-all-the-keys-with-the-same-value-in-a-python-dictionary
#   https://stackoverflow.com/questions/1841565/valueerror-invalid-literal-for-int-with-base-10
#---------------------------------------------

import re
from pathlib import Path

base_path = Path(__file__).parent.parent
file_path = (base_path / '../inputs/Day_7.txt').resolve()

aoc_input = []

with open(file_path) as file:
    aoc_input = file.read()
		
#---------------------------------------------
# Test Scenario
#---------------------------------------------        
aoc_input = """light red bags contain 1 bright white bag, 2 muted yellow bags.
dark orange bags contain 3 bright white bags, 4 muted yellow bags.
bright white bags contain 1 shiny gold bag.
muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
dark olive bags contain 3 faded blue bags, 4 dotted black bags.
vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
faded blue bags contain no other bags.
dotted black bags contain no other bags."""    

#aoc_input = """shiny gold bags contain 2 dark red bags.
#dark red bags contain 2 dark orange bags.
#dark orange bags contain 2 dark yellow bags.
#dark yellow bags contain 2 dark green bags.
#dark green bags contain 2 dark blue bags.
#dark blue bags contain 2 dark violet bags.
#dark violet bags contain no other bags."""    
        
aoc_input = aoc_input.split('\n')

def search_dictionary_part_1(dictionary, bag):
    bags_all = []
    
    #starting point // find all bags that have bag in its value
    bags = [k for k,v in dictionary.items() if bag in v]
    
    while bags:
        current_bag = bags[0]
        #print ('Current Bag:', current_bag)
        
        #add current_bag to bags_all if current_bag does not exist in bags_all list
        bags_all.append(current_bag) if current_bag not in bags_all else bags_all
        
        #get all other allowed bags for the current_bag and add it to the bags list
        bags.extend([k for k,v in dictionary.items() if current_bag in v])
        
        #remove current_bag as we have checked the dictionary for that entry now
        bags.remove(current_bag)
        
    return (bags_all)
    
def search_dictionary_part_2(dictionary, bag):
    #starting point // get all other bags in bag
    bags = dictionary.get(bag)
    
    print ('Starting Bags:', bags)
    
    bags_final = []
    
    for i in bags:
        
        bags_all = []
        bags_all.append(i)
        
        bags_final.append(i)
        
        i_split = i.split(' ')
        i_number = int(i_split[0])
        i_bag_name = ' '.join(i_split[1:])
        
        while bags_all:
            current_bag = bags_all[0]
            current_bag_split = current_bag.split(' ')
            current_number = int(current_bag_split[0])
            current_bag_name = ' '.join(current_bag_split[1:])
            other_bags = dictionary.get(current_bag_name)
            
            print ('Other Bags:', other_bags, '\n')
            
            previous_bag = bags_final[-1]
            previous_bag_split = previous_bag.split(' ')
            previous_number = int(previous_bag_split[0])
            previous_bag_name = ' '.join(previous_bag_split[1:])
            
            print ('Previous Bag:', previous_bag_name)
  
            print ('Current Bag:', current_bag_name)
            if i_bag_name != current_bag_name:
                #for k,v in dictionary.items():
                #    for vv in v:
                #        #extract only the current_bag_name
                #        print ('vv bag name', ' '.join(vv.split(' ')[1:]))
                #find all bags that have bag in its value
                contained_in = [k for k,v in dictionary.items() for vv in v if current_bag_name in ' '.join(vv.split(' ')[1:])]
                print ('contained in', contained_in)
                contained_in_A = ' '.join(([y for x in bags_final for y in contained_in if ' '.join(x.split(' ')[1:])==y and ((y==i_bag_name and other_bags==[]) or (y==previous_bag_name))]))
                print ('AA', contained_in_A, 'AA')
                contained_in_number_list = [x.split(' ')[0] for x in bags_final if contained_in_A in ' '.join(x.split(' ')[1:])]
                print ('cinl', contained_in_number_list)
                contained_in_number = int(contained_in_number_list[0])
                print ('contained in number', contained_in_number)
                
                final_number = (current_number*contained_in_number)
                print ('final_number', final_number)
                
                bags_final.append(str(final_number) + ' ' + current_bag_name)
            
            #get all other allowed bags for the current_bag and add it to the bags list
            bags_all.extend(other_bags)
            
            #remove current_bag as we have checked the dictionary for that entry now
            bags_all.remove(current_bag)
            
            print ('Intermediate Bags Final:', bags_final)
    
    print ('Bags Final', bags_final)
    return (bags_final)

if __name__ == '__main__':

    #---------------------------------------------
    # Part 1
    #---------------------------------------------
    bags_dictionary = {}

    for i in aoc_input:
        indexes = [j.start() for j in re.finditer('bag', i)]
        
        v = []
        for j in range(1, len(indexes)):
            #print (indexes, indexes[j], i[indexes[j-1]:indexes[j]])
            
            #grabbing last two words before the word 'bag'
            stg = i[indexes[j-1]:indexes[j]].split()
            bag_type = ' '.join(stg[-2:])
            
            #only append bag_type if NOT equal to 'no other'
            bag_type!='no other' and v.append(bag_type)
            
        #assigning first occurrence of 'bag' to the other allowed bags found in the for loop above
        bag = i[:indexes[0]].strip()
        bags_dictionary[bag] = v
        
        #print (bag, bags_dictionary[bag])
        
    answer = (search_dictionary_part_1(bags_dictionary, 'shiny gold'))
    print ('Part 1 Answer:', len(answer))
        
    #---------------------------------------------
    # Part 2
    #---------------------------------------------
    bags_dictionary = {}

    for i in aoc_input:
        indexes = [j.start() for j in re.finditer('bag', i)]
        
        v = []
        for j in range(1, len(indexes)):
            #print (indexes, indexes[j], i[indexes[j-1]:indexes[j]])
            
            #grabbing last three words before the word 'bag' (need to include the # now as well)
            stg = i[indexes[j-1]:indexes[j]].split()
            bag_type = ' '.join(stg[-3:])
            
            #only append bag_type if NOT equal to 'contain no other'
            bag_type!='contain no other' and v.append(bag_type)
            
        #assigning first occurrence of 'bag' to the other allowed bags found in the for loop above
        bag = i[:indexes[0]].strip()
        bags_dictionary[bag] = v
        
        #print (bag, bags_dictionary[bag])

    answer = (search_dictionary_part_2(bags_dictionary, 'shiny gold')) 
    count_bags = sum([int(i.split(' ')[0]) for i in answer])
    
    print ('Part 2 Answer:', count_bags)
