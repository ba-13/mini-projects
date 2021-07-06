#include "sudoku.h"

int main()
{
    printf("***********************************************\n");
    printf("                 Sudoku Solver                 \n");
    printf("***********************************************\n\n");
    printf("\n\nPlease note that this is not a complete implementation, this program will not find the optimum solution unless entries fit neatly.\n\n");

    // Variable declarations
    sudoku sudokuVal;
    int *sudoku1;
    sudoku1 = (int *)malloc(sudokuVal.N * sudokuVal.N * sizeof(int));

    // Taking input.
    printf("Please enter Size of Sudoku:   ");
    scanf("%d", &sudokuVal.N);
    printf("Please enter Rows in Boxes:    ");
    scanf("%d", &sudokuVal.R);
    printf("Please enter Columns in Boxes: ");
    scanf("%d", &sudokuVal.C);

    printf("\nPlease enter empty spaces as zeroes:\n\n");
    for (int i = 0; i < sudokuVal.N * sudokuVal.N; i++)
    {
        scanf("%d", &sudoku1[i]);
        if (sudoku1[i] < 0 || sudoku1[i] > sudokuVal.N)
        {
            printf("Invalid Input!\n");
            return 0;
        }
    }

    // Printing some stuff.
    printf("\nInitial Sudoku...\n");
    printSudoku(sudokuVal, sudoku1);
    printf("\nFinal Sudoku...\n");

    // Checking the validity, and if valid, changing the sudoku on place.
    int possible = CheckRow(0, sudokuVal, sudoku1);
    if (possible == -1)
        printf("Invalid Sudoku\n");
    else
        printSudoku(sudokuVal, sudoku1);

    return 0;
}