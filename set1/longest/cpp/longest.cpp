#include <iostream>
#include <fstream>
#include <bits/stdc++.h>

using namespace std;

#define MAX_M 500000
#define MAX_N 1000

int arr[MAX_M];
int N, M;

bool compare(const pair<int, int> &a, const pair<int, int> &b)
{
    if (a.first == b.first)
        return a.second < b.second;
    else
        return a.first < b.first;
}

int findInd(vector <pair<int, int>> &preSum, int m, int val)
{

    int left = 0;
    int right = m - 1;
    int mid;
    int ans = -1;

    while (left <= right) {
        mid = (left + right) / 2;
        if (preSum[mid].first <= val) {
            ans = mid;
            left = mid + 1;
        }
        else
            right = mid - 1;
    }
  
    return ans;
}

int longest(int arr[], int mdays, int hosp)
{
    int maxlen = 0;
    int minInd[mdays];
    int array[mdays];
    int sum = 0;
    vector<pair<int, int> > preSum;
    
    for (int i = 0; i < mdays; i++){
        array[i] = arr[i]*(-1.0) - hosp;
    }
  
    for (int i = 0; i < mdays; i++) {
        sum += array[i];
        preSum.push_back({ sum, i });
    }
  
    sort(preSum.begin(), preSum.end(), compare);

    minInd[0] = preSum[0].second;
  
    for (int i = 1; i < mdays; i++) {
        minInd[i] = min(minInd[i - 1], preSum[i].second);
    }
  
    sum = 0;
    for (int i = 0; i < mdays; i++) {
        sum = sum + array[i];
  
        if (sum >= 0)
            maxlen = i + 1;
        else {
            int ind = findInd(preSum, mdays, sum);
            if (ind != -1 && minInd[ind] < i)
                maxlen = max(maxlen, i - minInd[ind]);
        }
    }
  
    return maxlen;
}

int main(int argc, char *argv[]){
    /***
     * Special thanks to
     * https://www.geeksforgeeks.org/longest-subarray-having-average-greater-than-or-equal-to-x/
    ***/
    int s = 0;

    if(argc < 2){
        printf("Please provide input file!\n");
        exit(1);    
    }

    ifstream input;
    input.open(argv[1]);
    input >> M >> N;
    for(int i=0; i<M; i++){
        input >> arr[i];
        s += arr[i];
    }
    input.close();

    if((s*(-1.0))/(N * M) >= 1){
        cout << M << '\n';
        return 0;
    }

    int res = longest(arr, M, N);
    cout << res << '\n';

    return 0;
}