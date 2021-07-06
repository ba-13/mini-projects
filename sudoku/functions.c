#include "sudoku.h"

void printSudoku(sudoku sudokuVal, int sudoku1[])
{
    for (int i = 0; i < sudokuVal.N * sudokuVal.N; i++)
    {
        printf("%d ", sudoku1[i]);
        if (!((i + 1) % sudokuVal.N))
            printf("\n");
    }
    printf("\n");
}

int change(int i, int j, sudoku sudokuVal)
{
    return sudokuVal.N * i + j;
}

int row(int num, int i, int j, sudoku sudokuVal, int *sudoku1)
{
    for (int k = 0; k < sudokuVal.N; k++)
    {
        if (sudoku1[change(i, k, sudokuVal)] == num)
            return 0;
    }
    return 1;
}

int column(int num, int i, int j, sudoku sudokuVal, int *sudoku1)
{
    for (int k = 0; k < sudokuVal.N; k++)
    {
        if (sudoku1[change(k, j, sudokuVal)] == num)
            return 0;
    }
    return 1;
}

int box(int num, int i, int j, sudoku sudokuVal, int *sudoku1)
{
    //finding the topleft index
    int boxTL_C = (j / sudokuVal.C) * sudokuVal.C;
    int boxTL_R = (i / sudokuVal.R) * sudokuVal.R;
    for (int bi = 0; bi < sudokuVal.R; bi++)
    {
        for (int bj = 0; bj < sudokuVal.C; bj++)
        {
            if (sudoku1[change(boxTL_R + bi, boxTL_C + bj, sudokuVal)] == num)
                return 0;
        }
    }
    return 1;
}

int solve(int i, int j, sudoku sudokuVal, int *sudoku1, int num)
{
    return row(num, i, j, sudokuVal, sudoku1) && column(num, i, j, sudokuVal, sudoku1) && box(num, i, j, sudokuVal, sudoku1);
}

int CheckRow(int row, sudoku sudokuVal, int *sudoku1)
{
    if (row == sudokuVal.N)
        return 0;
    int j;
    int found = 0;
    for (j = 0; j < sudokuVal.N; j++)
    {
        if (sudoku1[change(row, j, sudokuVal)] == 0)
        {
            found = 1;
            break;
        }
    }
    // empty column in hand or the row is full.
    if (found)
    {
        int possible, i;
        for (i = 1; i < 10; i++)
        {
            possible = solve(row, j, sudokuVal, sudoku1, i);
            if (possible == 1)
            {
                sudoku1[change(row, j, sudokuVal)] = i;
                break;
            }
        }
        if (!possible)
        {
            printf("Invalid at row: %d and column: %d, tried fitting till %d\n", row, j, i - 1);
            printSudoku(sudokuVal, sudoku1);
            return -1;
        }
        CheckRow(row, sudokuVal, sudoku1);
    }
    else
        CheckRow(row + 1, sudokuVal, sudoku1);
    return 0;
}