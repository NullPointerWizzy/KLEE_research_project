#!/bin/bash

sudoku_program="../sudoku"
sudoku_fleury_program="./challenges/binaries/sudoku-FLEURY_Emmanuel"

get_solution_count() {
    local program=$1
    local grid=$2

    solutions=$("$program" -a "$grid" | grep "# Number of solutions:" | awk '{print $NF}')
    
    echo $solutions
}

check_inconsistency() {
    local program=$1
    local grid=$2

    result=$("$program" -a "$grid" | grep "inconsistent")

    if [[ -n "$result" ]]; then
        echo "Grid $grid is inconsistent"
    else
        echo "Grid $grid is consistent"
    fi
}

compare() {
    local grid_folder=$1

    for grid_file in "$grid_folder"/*
    do
        grid_name=$(basename "$grid_file")

        if [[ "$grid_name" == *inconsistent* ]]; then
            check_inconsistency "$sudoku_program" "$grid_file"
        else
            solutions_sudoku=$(get_solution_count "$sudoku_program" "$grid_file")
            solutions_fleury=$(get_solution_count "$sudoku_fleury_program" "$grid_file")

            echo "Grid: $grid_name"
            echo "Solutions (sudoku): $solutions_sudoku"
            echo "Solutions (sudoku-FLEURY_Emmanuel): $solutions_fleury"

            if [ "$solutions_sudoku" -eq "$solutions_fleury" ]; then
                echo "Same number of solutions"
            else
                echo "Different number of solutions"
            fi

            echo
        fi
    done
}

compare "grid-solver"
compare "challenges/level-01"
compare "challenges/level-02"
compare "challenges/level-03"
