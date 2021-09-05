#include <iostream>
#include <ctime>
#include <cstdlib>
#include <stdlib.h>
#include <limits>
#include <algorithm>

using namespace std;

int Difficulty = 4;

int PlayGame(int level, int code[]);

void Continue()
{
    cout << "\n\n\033[3;7mPRESS ENTER TO CONTINUE...\033[0m";
    cin.ignore(std::numeric_limits<streamsize>::max(), '\n');
    system("CLS");
}

void PrintIntroduction()
{
    cout << "You are invited to the time party held by \033[4;32mHawkings\033[0m...";
    Continue();

    cout << "But there is always a catch, right?";
    Continue();

    cout << "Here are all the data you need to travel back in time for the Party!";
    Continue();

    cout << "You have lost your way back in the 4th dimension, and all the data are scrambled the following manner: ";
    cout << "\n- There are \033[1;33m3 numbers\033[0m denoting the time coordinates.";
    cout << "\n- But this portal can only provide you their sum and product.";
    cout << "\n- You know the rules, now \033[1;34mget going!\033[0m";
    Continue();
    return;
}

int main()
{
    system("CLS");
    PrintIntroduction();
    int count = 0;
    int code[] = {28, 6, 2009};

    while (true)
    {
        count++;
        bool CanExit = PlayGame(count, code);
        if (CanExit)
        {
            cout << "Sorry mate, but you're playing with time. You died at level " << count
                 << ", and there was no escape from this whatsoever. \033[4;34mNext life? Press F9\033[0m";
            Continue();
            break;
        }
        else if (count >= 10)
        {
            cout << "Woah..Hold on mate, I think you are cheating!\n";
            cout << "Anyways, You seem to have arrived at 28 6 2009...at Westminster Abbey, London.\n";
            cout << "Go on...Stephen is waiting for you, \033[2;33myou did well.\033[0m";
            Continue();
            break;
        }
        std::cin.clear(); // Clears any errors
        // std::cin.ignore(); // Discard the buffer
    }

    return 0;
}

int PlayGame(int level, int code[])
{
    srand(time(0));
    if (level != 10)
    {
        for (int i = 0; i < 3; i++)
        {
            code[i] = rand() % (Difficulty * level);
            if (code[i] == 0)
                i--;
        }
    }
    int product = code[1] * code[2] * code[0], sum = code[1] + code[2] + code[0];
    cout << "You are on the \033[1;36mlevel " << level << "\033[0m";
    cout << "\n\nFor the needed 3 time coordinates,\n";
    cout << "\n > The Product you found is \033[1;33m" << product << "\033[0m";
    cout << "\n > The Sum you found is \033[1;33m" << sum << "\033[0m\n";

    /* 
    // Only for devPart
    cout << "\n- The actual coordinates are: " << code[0] << " " << code[1] << " " << code[2] << "\n\n";
    */

    cout << "Now enter what you think, were the coordinates: ";

    int time[3];
    cin >> time[0] >> time[1] >> time[2];
    sort(time, time + 3);
    sort(code, code + 3);
    int died = 0;
    for (int i = 0; i < 3; i++)
    {
        if (time[i] != code[i])
        {
            died = 1;
            break;
        }
    }
    if (died)
    {
        Continue();
        cout << "\n\033[1;31mOh No mate, what have you done?\033[0m";
        cout << "\n- Your choices were: " << time[0] << " " << time[1] << " " << time[2];
        cout << "\n- The actual coordinates were: " << code[0] << " " << code[1] << " " << code[2];
        Continue();
        return 1;
    }
    else
    {
        Continue();
        cout << "\033[1;33mPhew, ain't it, you passed!\033[0m";
        cout << "\n- Your choices were: " << time[0] << " " << time[1] << " " << time[2];
        cout << "\n- The actual coordinates were: " << code[0] << " " << code[1] << " " << code[2];
        Continue();
        return 0;
    }
}