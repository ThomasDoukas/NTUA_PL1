import sys
from collections import deque

if (len(sys.argv) < 2):
    print('Please provide input path!')
    sys.exit()

with open(sys.argv[1], 'r') as fd:
    line = fd.readline()
    N = int(line.split(' ')[0])
    M = int(line.split(' ')[1])
    rooms = list(map(list, fd.read().split('\n')))
    fd.close()

counter = 0
q = deque()

for i in range(N):
    for j in range(M):
        if(j == 0 and rooms[i][j] == 'L'):
            rooms[i][j] = 'X'
            counter += 1
            q.append((i, j))
        elif(j == M-1 and rooms[i][j] == 'R'):
            rooms[i][j] = 'X'
            counter += 1
            q.append((i, j))
        elif(i == 0 and rooms[i][j] == 'U'):
            rooms[i][j] = 'X'
            counter += 1
            q.append((i, j))
        elif(i == N-1 and rooms[i][j] == 'D'):
            rooms[i][j] = 'X'
            counter += 1
            q.append((i, j))

while(q):
    i, j = q.popleft()
    
    if(j != 0 and rooms[i][j-1]=='R'):
        rooms[i][j-1]='X'
        counter += 1
        q.append((i, j-1))
    if(j != M-1 and rooms[i][j+1]=='L'):
        rooms[i][j+1]='X'
        counter += 1
        q.append((i, j+1))
    if(i != 0 and rooms[i-1][j]=='D'):
        rooms[i-1][j]='X'
        counter += 1
        q.append((i-1, j))
    if(i != N-1 and rooms[i+1][j]=='U'):
        rooms[i+1][j]='X'
        counter += 1
        q.append((i+1, j))

print(N*M - counter)