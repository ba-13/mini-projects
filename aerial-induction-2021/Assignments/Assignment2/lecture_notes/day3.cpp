#include <bits/stdc++.h>
using namespace std;


vector<string> person;
vector<int> age;

class Person {
private:
    string name;
    int age;

public:
    Person(string, int);
    void setName(string n);
    void setAge(int a);

    string getName();
    int getAge();
};

Person::Person(string n="Hello", int a=21) {
    name = n;
    age = a;
}

void Person::setName(string n) {
    name = n;
}

void Person::setAge(int a) {
    age = a;
}

string Person::getName() {
    return name;
}

int Person::getAge() {
    return age;
}

int main() {
    Person p("hello", 21);
    cout<<p.getName()<<" "<<p.getAge()<<endl;
    return 0;
}