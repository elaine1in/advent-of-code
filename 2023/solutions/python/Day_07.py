import os
from collections import Counter, defaultdict
from pathlib import Path

file_name = ((os.path.basename(__file__)).split('.')[0])
base_path = Path(__file__).parent.parent
file_path = (base_path / '../inputs/{0}.txt'.format(file_name)).resolve()

with open(file_path) as file:
    raw_input = file.read().splitlines()

def rank_hand(hand: str) -> int:
    types = Counter(hand)

    count_joker = 0 if types.get("*",0)==5 else types.pop("*", 0)
    vals = sorted(types.values())
    vals[-1] += count_joker

    if vals==[5]:
        return 1
    elif vals==[1,4]:
        return 2
    elif vals==[2,3]:
        return 3
    elif vals==[1,1,3]:
        return 4
    elif vals==[1,2,2]:
        return 5
    elif vals==[1,1,1,2]:
        return 6
    else:
        return 7
    
def final_sort(d: dict, key: str, card_strength: list) -> tuple:
    return (d[key]['type'], [card_strength.index(key[i]) for i in range(len(key))])

def solve(part: int) -> int:
    card_strength_1 = ['A', 'K', 'Q', 'J', 'T', '9', '8', '7', '6', '5', '4', '3', '2']
    card_strength_2 = ['A', 'K', 'Q', 'T', '9', '8', '7', '6', '5', '4', '3', '2', 'J']
    games = defaultdict(lambda: defaultdict(list))
    for game in raw_input:
        hand, bid = game.split()
        games[hand]["type"] = rank_hand(hand=hand if part==1 else hand.replace('J', '*'))
        games[hand]["bid"] = int(bid)

    sorted_hands = sorted(games, key=lambda x: final_sort(d=games, key=x, card_strength=card_strength_1 if part==1 else card_strength_2))
    for i, hand in enumerate(sorted_hands):
        games[hand]["rank"] = len(sorted_hands)-i

    return sum([v["bid"]*v["rank"] for k, v in games.items()])

print (f"answer 1: {solve(part=1)}")
print (f"answer 2: {solve(part=2)}")
