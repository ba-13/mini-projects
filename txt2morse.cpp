// 2021-05-19 20:32:43
// Program to convert text to morse (only small letters) and morse to text (single words at a time).
#include <iostream>
#include <cstdlib>
#include <ctime>
#include <cassert>
#include <string>
#include <vector>
#include <bits/stdc++.h>

using std::cin;
using std::clock;
using std::cout;
using namespace std;
#define endl "\n"
#define fr(i, n) for (int i = 0; i < n; ++i)
#define ll long long

int toMorse(string);
int toText(string);
vector<string> splitter(string);

vector<pair<char, string>> morseMap;
void assign();

int main()
{

    clock_t start;
    double duration;
    start = clock();

    assign();
    cout << "Welcome to Morse-Txt converter (only small letters for now)";
    cout << "\nPlease enter (1 or 2)\n";
    cout << "\n1- Text to Morse.\n"
         << "2- Morse to Text (single word only)\n\n";
    int identifier;
    cin >> identifier;
    // cin.ignore();
    if (identifier != 2 && identifier != 1)
        return 0;

    cout << "\nEnter your text in a single line:\n";
    string gstring;

    getline(cin >> ws, gstring);

    if (identifier == 1)
        toMorse(gstring);
    else
        toText(gstring);

    cout << "Retry? (Y or --any--):\n";
    char retry = 'Y';
    cin >> retry;
    if (retry == 'Y' || retry == 'y')
    {
        cout << "\n\n\n\n\n\n";
        main();
    }

    duration = (clock() - start) / (double)CLOCKS_PER_SEC;
    cout << "Time: " << duration << endl;
}

void assign()
{
    morseMap.push_back({'0', "-----"});
    morseMap.push_back({'1', ".----"});
    morseMap.push_back({'2', "..---"});
    morseMap.push_back({'3', "...--"});
    morseMap.push_back({'4', "....-"});
    morseMap.push_back({'5', "....."});
    morseMap.push_back({'6', "-...."});
    morseMap.push_back({'7', "--..."});
    morseMap.push_back({'8', "---.."});
    morseMap.push_back({'9', "----."});
    morseMap.push_back({'a', ".-"});
    morseMap.push_back({'b', "-..."});
    morseMap.push_back({'c', "-.-."});
    morseMap.push_back({'d', "-.."});
    morseMap.push_back({'e', "."});
    morseMap.push_back({'f', "..-."});
    morseMap.push_back({'g', "--."});
    morseMap.push_back({'h', "...."});
    morseMap.push_back({'i', ".."});
    morseMap.push_back({'j', ".---"});
    morseMap.push_back({'k', "-.-"});
    morseMap.push_back({'l', ".-.."});
    morseMap.push_back({'m', "--"});
    morseMap.push_back({'n', "-."});
    morseMap.push_back({'o', "---"});
    morseMap.push_back({'p', ".--."});
    morseMap.push_back({'q', "--.-"});
    morseMap.push_back({'r', ".-."});
    morseMap.push_back({'s', "..."});
    morseMap.push_back({'t', "-"});
    morseMap.push_back({'u', "..-"});
    morseMap.push_back({'v', "...-"});
    morseMap.push_back({'w', ".--"});
    morseMap.push_back({'x', "-..-"});
    morseMap.push_back({'y', "-.--"});
    morseMap.push_back({'z', "--.."});
    morseMap.push_back({'.', ".-.-.-"});
    morseMap.push_back({',', "--..--"});
    morseMap.push_back({'?', "..--.."});
}

int toMorse(string gstring)
{
    for (int i = 0; i < gstring.length(); i++)
    {
        if (gstring[i] == 32)
            cout << "\t ";
        else
        {
            char c = gstring[i];
            if (gstring[i] >= 'A' && gstring[i] <= 'Z')
                c = c - 'A' + 'a';

            if (c >= 0 && c <= 9)
                cout << morseMap[(int)c].second << " ";
            else if (c >= 'a' && c <= 'z')
                cout << morseMap[c - 'a' + 10].second << " ";
            else if (c == '.')
                cout << morseMap[36].second << " ";
            else if (c == '?')
                cout << morseMap[38].second << " ";
            else if (c == ',')
                cout << morseMap[37].second << " ";
        }
    }
    cout << "\n\n";
}

vector<string> splitter(string gstring)
{
    vector<string> letters;
    char del = ' ';
    int start = 0;
    int end = gstring.find(del);
    letters.push_back(gstring.substr(start, end - start));
    while (end != -1)
    {
        start = end + 1;
        end = gstring.find(del, start);
        letters.push_back(gstring.substr(start, end - start));
    }
    return letters;
}

int toText(string gstring)
{
    //splitting the string for each letter
    vector<string> letters = splitter(gstring);

    cout << "\n";
    for (int i = 0; i < letters.size(); ++i)
    {
        for (int j = 0; j < morseMap.size(); j++)
            if (letters[i] == morseMap[j].second)
            {
                cout << morseMap[j].first;
                break;
            }
    }
    cout << "\n\n";
    return 0;
}