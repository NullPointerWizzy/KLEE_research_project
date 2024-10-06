#!/bin/bash
for ((i = 1; i <= 891; i++)); do
    FILE="klee-out-0/test$(printf "%06d" $i).ktest"

    echo "Analyse $KTEST_FILE :"
    ktest-tool $FILE
    echo " "
    KTEST_FILE=$FILE ./sudoku 
    echo " "
    echo " "
done