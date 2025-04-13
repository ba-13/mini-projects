#include <bits/stdc++.h>
using namespace std;


void swap(int &a, int &b) {
    int t;
    t = a;
    a = b;
    b = t;
}

int main() {

    int x=1, y =5;
    // cout<<x<<" "<<y<<"\n";
    // swap(x,y);
    // cout<<x<<" "<<y<<"\n";


    // Basics of pointers
    int *arr;
    // int aa[] = {1,2,3,4};
    // cout<<sizeof(aa)<<"\n";

    // arr = (int *)malloc(5 * sizeof(int));
    // for(int i=0; i<5; i++) {
    //     arr[i] = i;
    //     cout<<arr[i]<<" ";
    // }
    // cout<<"\n";

    // int *arr_new = (int *)realloc(arr, 7*sizeof(int));
    // arr_new[5] = 50, arr_new[6] = 60;
    // arr_new[1] = 10;
    // for(int i=0; i<7; i++) cout<<arr_new[i]<<" ";
    // cout<<"\n";

    // free(arr_new);

   int mat[3][4] = { {1, 2, 3, 4}, {5, 6, 7, 8}, {9, 10, 11, 12} };

   // 1 2 3 4
   // 5 6 7 8
   // 9 10 11 12

   // 1 2 3 4 5 6 7 8 9 10 11 12

    //2D array using array of pointers

    int r = 3, c = 4;
    int *ptr_arr[r];
    for(int i=0; i<r; i++) ptr_arr[i] = (int*)malloc(c*sizeof(int));

    cout<<ptr_arr<<"\n";
    //ptr_arr[0]
    for(int i=0; i<r; i++) cout<<ptr_arr[i]<<" ";

    for(int i=0; i<r; i++) {
        for(int j=0; j<c; j++) {
            *(*(ptr_arr+i)+j) = mat[i][j];
            // ptr_arr[i][j] = mat[i][j]
            cout<<ptr_arr[i][j]<<" ";
        }
        cout<<"\n";
    }

    for(int i=0; i<r; i++) free(ptr_arr[i]);
    return 0;
}