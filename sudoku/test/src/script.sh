#!/bin/bash
for ((i = 1; i <= 16; i++)); do
    FILE="klee-out-0/test$(printf "%06d" $i).ktest"

    echo "Analyse $KTEST_FILE :"
    ktest-tool $FILE
    echo " "
    klee-replay ./sudoku $FILE 
    echo " "
    echo " "
done