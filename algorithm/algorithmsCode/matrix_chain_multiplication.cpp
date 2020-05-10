// https://practice.geeksforgeeks.org/problems/matrix-chain-multiplication/0

#include<bits/stdc++.h>
#include <ext/pb_ds/assoc_container.hpp>
#include <cmath>
using namespace __gnu_pbds;
using namespace std;
 
typedef tree<int,null_type,less<int>,rb_tree_tag,tree_order_statistics_node_update> indexed_set;
 
typedef long long lli;
typedef long li;
typedef pair<int,int> PI;
typedef pair<long,int> PLI;
typedef pair<int,long> PIL;
typedef pair<long, long> PL;
typedef pair<long long, long long> PLL;
typedef vector<int> VI;
typedef vector<long> VL;
typedef vector<long long> VLL;
typedef priority_queue<int> PQ;
typedef priority_queue<long> PQL;
typedef priority_queue<long long> PQLL;
#define FAST ios::sync_with_stdio(0)
#define forz(n) for (long i = 0; i < n; i++)
#define forv(i,x,y) for (long i=x; i<y; i++)
#define rforz(a,n) for (long i = a; i < n; i++)
#define forlz(n) for (long int i = 0; i < n; i++)
#define TRAV(it, v) for(auto it = v.begin(); it != v.end(); it++) 
#define MP make_pair
#define PB push_back
#define F first
#define S second
#define SQ(a) (a)*(a)
#define UM unordered_map
#define US unordered_set
#define LB(v,x) lower_bound(v.begin(),v.end(),x);
#define UB(v,x) upper_bound(v.begin(),v.end(),x);
#define CUBE(a) (a)*(a)*(a)
#define SORT(v) sort(v.begin(),v.end());
#define SORTC(v,c) sort(v.begin(),v.end(),c);
#define Pi 3.14159265358979323846
 
 
#define module 1000000007

lli matrix_multiplication(vector<vector<lli>> &vec,int l,int r,vector<lli> arr){
    if(l==r){
        return 0;
    }else{
        if(vec[l][r]>0){
            return vec[l][r];
        }else{
            lli best = INT_MAX;
            forv(i,l,r){
                lli t = matrix_multiplication(vec,l,i,arr) + matrix_multiplication(vec,i+1,r,arr) + arr[l-1]*arr[i]*arr[r];
                best = min(best,t);
            }
            vec[l][r] = best;
            return best;
        }
    }
}
 
void solve(){
    int n;
    cin>>n;
    vector<lli> arr(n);
    forz(n) cin>>arr[i];
    vector<lli> vec[n];
    vector<vector<lli>> vv(n);
    forv(i,1,n){
        vv[i] = vector<lli>(n);
    }
    lli best = matrix_multiplication(vv,1,n-1,arr);
    cout<<best<<'\n';
    // forv(i,1,n){
    //     forv(j,0,i){
    //         cout<<vv[i][j]<<" ";
    //     }
    //     cout<<'\n';
    // }
    return;
}

int main(){
    FAST;
    cin.tie(0);
    cout.tie(0);
    int t;
    cin>>t;
    while(t--){
        solve();
    }
    
    return 0;
}
