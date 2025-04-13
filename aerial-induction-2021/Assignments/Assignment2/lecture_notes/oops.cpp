#include <bits/stdc++.h>
using namespace std;

class Person {
protected:
    string name;
    int age;

public:
    Person(string n, int a);
    void setName(string n);
    void setAge(int a);

    string getName();
    int getAge();
};

Person::Person(string n, int a) {
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

class Student: public Person {
protected:
    string dept;
    int year;
public:

    void setDept(string d);
    void setYear(int y);
    Student(string n, int a, string d, int y);

    string getDept() { return dept; }
    int getYear() { return year; }
    void printDeets();
};

Student::Student(string n, int a, string d, int y) : Person(n,a) {
    //Person(n,a);
    dept = d;
    year = y;
}

void Student::setDept(string d) {
    dept = d;
}

void Student::setYear(int y) {
    year = y;
}

void Student::printDeets() {
    cout<<"Name : "<<getName()<<endl;
    cout<<"Age  : "<<getAge()<<endl;
    cout<<"Dept : "<<getDept()<<endl;
    cout<<"Year : "<<getYear()<<endl;
}

int main() {
    Student s("Rohan", 20, "EE", 2019);
    // s.setName("Rohan");
    // s.setAge(20);
    // s.setDept("EE");
    // s.setYear(2019);
    s.printDeets();
    return 0;
}