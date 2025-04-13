#include <bits/stdc++.h>
using namespace std;

void showlist(list<int> l) {
    list<int> :: iterator it;
    for(it = l.begin(); it != l.end(); it++) {
        cout<<*it<<" ";
    }
    cout<<"\n";
}

void showStack(stack<int> S) {
    while(!S.empty()) {
        cout<<S.top()<<" ";
        S.pop();
    }
    cout<<"\n";
}

void modifyVec(vector<int> &vec) {
    vec[0] = 8;
}

void showVector(vector<int> vec) {
    int n = vec.size();
    for(int i=0; i<n; i++) cout<<vec[i]<<" ";
    cout<<"\n";
}

void showQueue(queue<int> Q) {
    while(!Q.empty()) {
        cout<<Q.front()<<" ";
        Q.pop();
    }
    cout<<"\n";
}

// int main() {
//     queue<int> q;
//     q.push(20);
//     q.push(30);
//     q.push(40);
//     showQueue(q);
//     q.pop();
//     q.push(100);
//     showQueue(q);
//     return 0;
// }

// 30 40 100

// int main() {

//     vector<int> v = {1,2,3,4,5};
//     showVector(v);
//     modifyVec(v);
//     showVector(v);
//     return 0;
// }

// int main() {
//     stack<int> S;

//     S.push(31);
//     S.push(2);
//     S.push(5);
//     showStack(S);
//     //S.pop();
//     S.push(55);
//     showStack(S);

//     return 0;

// }

//55
//2
//31

// int main() {
//     list<int> l1, l2;
//     int i=0;
//     for(i=0; i<10; i++) {
//         l1.push_back(i);
//         l2.push_front(i);
//     }

//     showlist(l1);
//     showlist(l2);

//     cout<<l1.front()<<" "<<l1.back()<<"\n";

//     l1.pop_front();
//     showlist(l1);

//     return 0;
// }


int main() {
    vector<int> vec = {5,6,1,2,10,3};
    cout<<vec.size()<<"\n";
    int i=0;
    for(i=0; i<6; i++)cout<<vec[i]<<" ";
    cout<<"\n";
    vec.push_back(60);
    cout<<vec.size()<<"\n";
    int n = vec.size();
    for(i=0; i<n; i++) cout<<vec[i]<<" ";
    cout<<"\n";

    sort(vec.begin(), vec.end());
    for(i=0; i<n; i++) cout<<vec[i]<<" ";
    cout<<"\n";

    vector<int> v;
    for(i=0; i<5; i++) {
        v.push_back(i);
        cout<<v[i]<<" ";
    }
    cout<<"\n";

    vector<vector<int>> mat;
    mat.push_back(v);
    mat.push_back(vec);
    cout<<mat[1][2];
    return 0;
}