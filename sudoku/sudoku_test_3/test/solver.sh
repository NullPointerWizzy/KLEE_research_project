#!/bin/bash

run_command() {
    local command=$1
    local label=$2

    echo "Running test: $label"
    echo "Command: $command"
    
    { time $command ; } 2>&1 | grep real | awk -v label="$label" '{print "Time for " label ": " $2}'
    echo
}

run_command "../sudoku -a grid-solver/*" "Grid Solver"
run_command "../sudoku -a challenges/level-01/*" "Level 01"
run_command "../sudoku -a challenges/level-02/*" "Level 02"
run_command "../sudoku -a challenges/level-03/*" "Level 03"
