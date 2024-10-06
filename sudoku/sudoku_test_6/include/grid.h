#ifndef GRID_H
#define GRID_H

#include "colors.h"

#include <stdbool.h>
#include <stdio.h>

#define DEFAULT_SIZE 9
#define MAX_GRID_SIZE 64
#define EMPTY_CELL '_'

/* Table to convert a color to char */
static const char color_table[] = "123456789"
                                  "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
                                  "@"
                                  "abcdefghijklmnopqrstuvwxyz"
                                  "&*";

typedef struct {
  size_t row;
  size_t column;
  colors_t color;
} choice_t;

/* Sudoku grid (forward declaration to hide the implementation) */
typedef struct _grid_t grid_t;

/* Enum as output type for grid_heuristics */
typedef enum { grid_solved, grid_unsolved, grid_inconsistent } status_t;

/* Check if the 'size' is a correct size */
bool grid_check_size (const size_t size);

/* Allocation of the grid of size 'size' */
grid_t *grid_alloc (size_t size);

/* Free the memory of the grid 'grid' */
void grid_free (grid_t *grid);

/* Print the grid 'grid' in the file 'fd' */
void grid_print (const grid_t *grid, FILE *fd);

/* Check if the char 'c' is a correct char for the grid 'grid' */
bool grid_check_char (const grid_t *grid, const char c);

/* Create a new grid, which is a copy of 'grid' */
grid_t *grid_copy (const grid_t *grid);

/* Return the correspondent string of the cell ('row','column') of the grid
 * 'grid' */
char *grid_get_cell (const grid_t *grid, const size_t row, const size_t column);

/* Return the colors of the cell ('row','column') of the grid
 * 'grid' */
colors_t grid_get_cell_colors (const grid_t *grid, const size_t row,
                               const size_t column);

/* Return the size of the grid 'grid' */
size_t grid_get_size (const grid_t *grid);

/* Set the value of the cell ('row','column') at the correspondent value of char
 * 'color' */
void grid_set_cell (grid_t *grid, const size_t row, const size_t column,
                    const char color);

/* Set the value of the cell ('row','column') at a possible colors  */
void grid_set_cell_random (grid_t *grid, const size_t row, const size_t column);

/* Set the value of the cell ('row','column') at the colors 'colors' */
void grid_set_cell_colors (grid_t *grid, const size_t row, const size_t column,
                           const colors_t colors);

/* Check if the 'grid' is solved*/
bool grid_is_solved (grid_t *grid);

/* Check if the 'grid' is consistent */
bool grid_is_consistent (grid_t *grid);

/* Applies heuristic to the 'grid' with heuristics*/
status_t grid_heuristic (grid_t *grid);

/* Check if the color set of the 'choice' is empty */
bool grid_choice_is_empty (const choice_t choice);

/* Apply a 'choice' to the grid*/
void grid_choice_apply (grid_t *grid, const choice_t choice);

/* Discard a 'choice' to the grid */
void grid_choice_discard (grid_t *grid, const choice_t choice);

/* Write the 'choice' in the file 'fd' */
void grid_choice_print (const choice_t choice, FILE *fd);

/* Choose the smallest set of colors in all the grid and select the rightmost
 * color if not 'random' else choose randomly  and return this choice */
choice_t *grid_choice (grid_t *grid);

#endif /*GRID_H*/