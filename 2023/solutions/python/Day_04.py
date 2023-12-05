import os
import re
from pathlib import Path

file_name = ((os.path.basename(__file__)).split('.')[0])
base_path = Path(__file__).parent.parent
file_path = (base_path / '../inputs/{0}.txt'.format(file_name)).resolve()

with open(file_path) as file:
    raw_input = file.read().splitlines()

# raw_input = [
#     "Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53"
#     ,"Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19"
#     ,"Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1"
#     ,"Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83"
#     ,"Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36"
#     ,"Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11"
# ]

def solve(part: int) -> int:
    answer = 0
    number_of_cards = {i: 1 for i in range(1, len(raw_input)+1)}
    for card in raw_input:
        pattern = re.compile("Card( {1,})([0-9]{1,}): (.*)")
        pattern_match = pattern.match(card)
        card_num = int(pattern_match.group(2))
        # print (f"{card_num = }")
        raw_winning_numbers, raw_card_numbers = pattern_match.group(3).split(" | ")
        # print (f"{raw_winning_numbers = } | {raw_card_numbers = }")
        winning_numbers = set(raw_winning_numbers.split())
        card_numbers = set(raw_card_numbers.split())
        number_of_matches = len(winning_numbers & card_numbers)
        answer += 2**(number_of_matches-1) if number_of_matches>0 else 0
        # print (f"{winning_numbers = } | {card_numbers = } | {number_of_matches = }")

        for i in range(1, number_of_matches+1):
            number_of_cards[card_num+i] += 1
            number_of_cards[card_num+i] += number_of_cards[card_num]-1
            # print (f"{number_of_cards = }")
        
    return answer if part == 1 else sum(number_of_cards.values())

print (f"answer: {solve(part=1)}")
print (f"answer: {solve(part=2)}")
