#include <bits/stdc++.h>
using namespace std;

// PRIORITY QUEUE
int main() {
    priority_queue<int> Q;
    Q.push(10);
    Q.push(1);
    Q.push(20);
    Q.push(30);

    cout<<Q.top()<<"\n";
    Q.pop();
    cout<<Q.top()<<"\n";
    Q.pop();
    return 0;
}

// 1 10 20 

// MAPS
// int main() {
//     map<string, int> M;

//     M["rohan"] = 1;
//     M["hello"] = 10;
//     M["helloiitk"] = -1;

//     map<string, int>::iterator itr;
//     for(itr=M.begin(); itr!=M.end(); itr++) {
//         cout<<itr->first<<" "<<itr->second<<"\n";
//     }
//     return 0;
// }


// PAIRS
// int main() {
//     pair<int, string> p;
//     p = {1, "Rohan"};

//     vector<pair<int, string>> vec;

//     vec.push_back({1, "Rohan"});
//     vec.push_back({2, "Hello"});
//     vec.push_back({3, "Campus khol do ;-;"});

//     vector<pair<int, string>>::iterator itr;

//     for(itr=vec.begin(); itr!=vec.end(); itr++) {
//         pair<int, string> p1 = *itr;
//         cout<<itr->first<<" "<<itr->second<<"\n";
//         //cout<<p1.first<<" "<<p1.second<<"\n";
//     }

//     return 0;
// } 

// int main() {
//     multiset<int> s1;

//     s1.insert(40);
//     s1.insert(30);
//     s1.insert(60);
//     s1.insert(50);
//     s1.insert(20);

//     multiset<int>::iterator itr;

//     for(itr=s1.begin(); itr!=s1.end(); itr++) cout<<*itr<<" ";
//     cout<<"\n";

//     s1.erase(40);
//     cout<<s1.count(40)<<"\n";

//     s1.insert(30);
//     cout<<s1.count(30)<<"\n";
//     s1.erase(s1.find(30));
//     cout<<s1.count(30)<<"\n";

//     return 0;
// }


// SETS 

// int main() {
//     set<int> s1;

//     s1.insert(40);
//     s1.insert(30);
//     s1.insert(60);
//     s1.insert(50);
//     s1.insert(20);

//     set<int>::iterator itr;

//     for(itr=s1.begin(); itr!=s1.end(); itr++) cout<<*itr<<" ";
//     cout<<"\n";

//     s1.erase(40);
//     cout<<s1.count(40)<<"\n";

//     s1.insert(30);
//     cout<<s1.count(30)<<"\n";
//     s1.erase(30);
//     cout<<s1.count(30)<<"\n";

//     return 0;
// }

// 1 4 2 10 7 8 3 100 99 80

// 1 2 3 4 7 8 10 80 99 100