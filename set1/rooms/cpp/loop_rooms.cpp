#include <iostream>
#include <fstream>
#include <bits/stdc++.h>  
#include <vector>
#include <queue>

using namespace std;

#define MAX_M 1000
#define MAX_N 1000

int N, M;
char room[MAX_N][MAX_M];

int main(int argc, char *argv[]){

    if(argc < 2){
        printf("Please provide input file!\n");
        exit(1);    
    }

    ifstream input;
    input.open(argv[1]);
    
    input >> N >> M;

    int counter = 0;
    queue< pair<int,int> > q;

    while (!input.eof())
    {
        for (int i = 0; i < N; i++){
            for (int j = 0; j < M; j++){
                input >> room[i][j];
                if(j == 0 && room[i][j] == 'L'){
                    room[i][j] = 'X';
                    counter++;
                    q.push({i,j});
                }
                else if(j == M-1 && room[i][j] == 'R'){
                    room[i][j] = 'X';
                    counter++;
                    q.push({i,j});
                }
                else if(i == 0 && room[i][j] == 'U'){
                    room[i][j] = 'X';
                    counter++;
                    q.push({i,j});
                }
                else if(i == N-1 && room[i][j] == 'D'){
                    room[i][j] = 'X';
                    counter++;
                    q.push({i,j});
                }
            }
        }
    }
    input.close();

    while (!q.empty()){
        int i = q.front().first;
        int j = q.front().second;

        // Check left 
        if(j != 0 && room[i][j-1]=='R'){
            room[i][j-1]='X';
            counter++;
            q.push({i, j-1});
        }
        // Check right 
        if(j != M-1 && room[i][j+1]=='L'){
            room[i][j+1]='X';
            counter++;
            q.push({i, j+1});
        }
        // Check up
        if(i != 0 && room[i-1][j]=='D'){
            room[i-1][j]='X';
            counter++;
            q.push({i-1, j});
        }
        // Check down
        if(i != N-1 && room[i+1][j]=='U'){
            room[i+1][j]='X';
            counter++;
            q.push({i+1, j});
        }
        q.pop();

    }

    cout << N*M - counter << '\n';

    return 0;
}