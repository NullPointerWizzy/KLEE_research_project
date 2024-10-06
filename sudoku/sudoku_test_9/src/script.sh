#!/bin/bash
for ((i = 1; i <= 14; i++)); do
    FILE="klee-out-0/test$(printf "%06d" $i).ktest"

    echo "Analyse $FILE :"
    
    ktest-tool $FILE
    echo " "
    KTEST_FILE=$FILE     
    klee-replay ./sudoku $FILE 
    echo " "
    echo " "
done