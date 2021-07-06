#include <stdio.h>
#include <stdlib.h>

typedef struct sudoku
{
    int N, R, C;
} sudoku;

void printSudoku(sudoku sudokuVal, int sudoku1[]);
int change(int i, int j, sudoku sudokuVal);
int row(int num, int i, int j, sudoku sudokuVal, int *sudoku1);
int column(int num, int i, int j, sudoku sudokuVal, int *sudoku1);
int box(int num, int i, int j, sudoku sudokuVal, int *sudoku1);
int solve(int i, int j, sudoku sudokuVal, int *sudoku1, int num);
int CheckRow(int row, sudoku sudokuVal, int *sudoku1);