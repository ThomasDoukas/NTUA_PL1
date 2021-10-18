# Goat.pl as seen in PL1-Ntua's lectures will be used as a reference for this problem.
import sys
from collections import deque

if (len(sys.argv) < 2):
    print('Please provide input path!')
    sys.exit()

queue = tuple()
stack = tuple()
moves = ''
visited = {}
solved = False

with open(sys.argv[1], 'r') as fd:
    line = fd.readline()
    N = int(line.split('\n')[0])
    queue = tuple(map(int, fd.readline().split( )))
    fd.close()

# tuple for starting root of bfs
init = (moves, queue, stack)
q = deque([init])

def is_sorted(l):
    for i, el in enumerate(l[1:]):
        if(el < l[i]):
            return False
    return True

def next_move(t):
    res = tuple()

    # Q move
    # remove first element of queue
    if(t[1]):
        val = t[1][0]
        q_queue = t[1][1:]
        # and add it to stack head
        q_stack = t[2][:]
        q_stack += (val, )
        res += ((t[0]+'Q', q_queue, q_stack), )

    # S move
    # remove element from stack head
    if(t[2]):
        val = t[2][-1]
        s_stack = t[2][:-1]
        # and add to queue as last element
        s_queue = t[1][:]
        s_queue += (val, )
        res += ((t[0]+'S', s_queue, s_stack), )

    return res

# run bfs
while q:
    state = q.popleft()
    # print(s)
    if(not state[2] and is_sorted(state[1])):
        solved = True
        break
    for next_state in next_move(state):
        h = hash((next_state[1], next_state[2]))
        if h not in visited:
            visited[h] = 1
            q.append(next_state)

if solved:
    if(state[0] == ''):
        print('empty')
    else:
        print(state[0])
