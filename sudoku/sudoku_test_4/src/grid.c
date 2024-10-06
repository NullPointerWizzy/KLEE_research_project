#include "grid.h"

#include <stdlib.h>
#include <unistd.h>

#include <assert.h>
#include <math.h>
#include <time.h>

/* Internal structure (hidden from outside) for a sudoku grid */
struct _grid_t {
  size_t size;
  colors_t **cells;
};

/************ GRID_CHECK_SIZE ************/
bool grid_check_size (const size_t size) {
  return size == 1 || size == 4 || size == 9 || size == 16 || size == 25 ||
         size == 36 || size == 49 || size == 64;
}

/************ GRID_ALLOC ************/
grid_t *grid_alloc (size_t size) {
  if (!grid_check_size (size)) {
    return NULL;
  }

  grid_t *grid = malloc (sizeof (grid_t));
  if (grid == NULL) {
    return NULL;
  }

  grid->size = size;

  grid->cells = malloc (size * sizeof (colors_t *));
  if (grid->cells == NULL) {
    free (grid);
    return NULL;
  }

  for (size_t i = 0; i < size; i++) {
    grid->cells[i] = malloc (size * sizeof (colors_t));

    if (grid->cells[i] == NULL) {
      for (size_t j = 0; j < i; j++) {
        free (grid->cells[i]);
      }

      free (grid->cells);
      free (grid);
      return NULL;
    }
  }
  return grid;
}

/************ GRID_FREE ************/
void grid_free (grid_t *grid) {
  if (grid == NULL) {
    return;
  }

  if (grid->cells == NULL) {
    free (grid);
    return;
  }

  for (size_t i = 0; i < grid->size; i++) {
    free (grid->cells[i]);
  }

  free (grid->cells);
  free (grid);
}

/************ GRID_PRINT ************/
void grid_print (const grid_t *grid, FILE *fd) {
  if (grid == NULL) {
    return;
  }

  for (size_t row = 0; row < grid->size; row++) {
    for (size_t column = 0; column < grid->size; column++) {

      if (colors_is_singleton (grid->cells[row][column])) {
        for (size_t index = 0; index < grid->size; index++) {
          if (colors_is_in (grid->cells[row][column], index)) {
            fputc (color_table[index], fd);
          }
        }

      } else {
        fputc ('_', fd);
      }

      fputc (' ', fd);
    }

    fputc ('\n', fd);
  }

  fputc ('\n', fd);
}

/************ GIRD_CHECK_CHAR ************/
bool grid_check_char (const grid_t *grid, const char c) {
  assert (grid != NULL);

  if (c == EMPTY_CELL) {
    return true;
  }

  for (size_t i = 0; i < grid->size; i++) {
    if (c == color_table[i]) {
      return true;
    }
  }

  return false;
}

/************ GRID_COPY ************/
grid_t *grid_copy (const grid_t *grid) {
  if (grid == NULL) {
    return NULL;
  }

  grid_t *grid_copy = grid_alloc (grid->size);
  if (grid_copy == NULL) {
    return NULL;
  }

  for (size_t row = 0; row < grid_copy->size; row++) {
    for (size_t column = 0; column < grid_copy->size; column++) {
      grid_copy->cells[row][column] = grid->cells[row][column];
    }
  }

  return grid_copy;
}

/************ GRID_GET_CELL ************/
char *grid_get_cell (const grid_t *grid, const size_t row,
                     const size_t column) {
  if (grid == NULL || row >= grid->size || column >= grid->size) {
    return NULL;
  }

  char *buffer = malloc ((grid->size + 1) * sizeof (char));
  if (buffer == NULL) {
    return NULL;
  }

  int buffer_size = 0;
  for (size_t index = 0; index < grid->size; index++) {
    if (colors_is_in (grid->cells[row][column], index)) {
      buffer[buffer_size] = color_table[index];
      buffer_size++;
    }
  }

  buffer[buffer_size] = '\0';

  return buffer;
}

/************ GRID_GET_CELL_COLORS ************/
colors_t grid_get_cell_colors (const grid_t *grid, const size_t row,
                               const size_t column) {
  return grid->cells[row][column];
}

/************ GRID_SIZE ************/
size_t grid_get_size (const grid_t *grid) {
  if (grid == NULL) {
    return 0;
  }
  return grid->size;
}

/************ GRID_SET_CELL ************/
void grid_set_cell (grid_t *grid, const size_t row, const size_t column,
                    const char color) {
  if (grid == NULL || row >= grid->size || column >= grid->size) {
    return;
  }

  for (size_t index = 0; index <= grid->size; index++) {
    if (color_table[index] == color) {
      grid->cells[row][column] = colors_set (index);
      return;
    }
  }

  grid->cells[row][column] = colors_full (grid->size);
}

/************ GRID_SET_CELL_RANDOM ************/
void grid_set_cell_random (grid_t *grid, const size_t row,
                           const size_t column) {
  if (grid == NULL || row >= grid->size || column >= grid->size) {
    return;
  }

  grid->cells[row][column] = colors_random (grid->cells[row][column]);
}

/************ GRID_SET_CELL_COLORS ************/
void grid_set_cell_colors (grid_t *grid, const size_t row, const size_t column,
                           const colors_t colors) {
  if (grid == NULL || row >= grid->size || column >= grid->size) {
    return;
  }

  grid->cells[row][column] = colors;
}

/************ SUBGRID_APPLY ************/
bool subgrid_apply (grid_t *grid,
                    bool (*func) (colors_t *subgrid[], const size_t size),
                    bool is_heuristic) {
  assert (grid != NULL);
  size_t size = grid->size;
  colors_t *subgrid_row[size];
  colors_t *subgrid_column[size];
  colors_t *subgrid_block[size];
  bool test = false;

  size_t cpt = 0;
  size_t sqrt_size = sqrt (size);
  size_t x_block;
  size_t y_block;

  for (size_t row = 0; row < size; row++) {
    for (size_t column = 0; column < size; column++) {

      subgrid_row[column] = &grid->cells[row][column];
      subgrid_column[column] = &grid->cells[column][row];

      if (column == sqrt_size * (1 + cpt)) {
        cpt++;
      }

      x_block = (row / sqrt_size) * sqrt_size;
      y_block = (row % sqrt_size) * sqrt_size;

      subgrid_block[column] =
          &grid->cells[x_block + cpt][y_block + column % sqrt_size];
    }

    cpt = 0;

    if (is_heuristic) {
      test = func (subgrid_row, size) || test;
      test = func (subgrid_column, size) || test;
      test = func (subgrid_block, size) || test;
    }

    if (!is_heuristic &&
        (!func (subgrid_row, size) || !func (subgrid_column, size) ||
         !func (subgrid_block, size))) {
      return true;
    }
  }
  return test;
}

/************ GRID_IS_SOLVED ************/
bool grid_is_solved (grid_t *grid) {
  assert (grid != NULL);

  for (size_t row = 0; row < grid->size; row++) {
    for (size_t column = 0; column < grid->size; column++) {
      if (!colors_is_singleton (grid->cells[row][column])) {
        return false;
      }
    }
  }

  return true;
}

/************ GRID_IS_CONSISTENT ************/
bool grid_is_consistent (grid_t *grid) {
  assert (grid != NULL);

  return !subgrid_apply (grid, subgrid_consistency, false);
}

/************ GRID_HEURISTICS ************/
status_t grid_heuristic (grid_t *grid) {
  if (grid == NULL) {
    return grid_inconsistent;
  }

  while (subgrid_apply (grid, subgrid_heuristics, true))
    ;

  if (!grid_is_consistent (grid)) {
    return grid_inconsistent;
  }

  if (grid_is_solved (grid)) {
    return grid_solved;
  }

  return grid_unsolved;
}

/************ GRID_CHOICE_IS_EMPTY ************/
bool grid_choice_is_empty (const choice_t choice) { return choice.color == 0; }

/************ GRID_CHOICE_APPLY ************/
void grid_choice_apply (grid_t *grid, const choice_t choice) {
  assert (grid != NULL);

  grid->cells[choice.row][choice.column] = choice.color;
}

/************ GRID_CHOICE_DISCARD ************/
void grid_choice_discard (grid_t *grid, const choice_t choice) {
  assert (grid != NULL);

  colors_t new_color =
      colors_subtract (grid->cells[choice.row][choice.column], choice.color);
  grid->cells[choice.row][choice.column] = new_color;
}

/************ GRID_CHOICE_PRINT ************/
void grid_choice_print (const choice_t choice, FILE *fd) {
  fprintf (fd, "The choice is row = %li, column = %li and color = %li.\n",
           choice.row, choice.column, choice.color);
}

/************ GRID_CHOICE ************/
choice_t *grid_choice (grid_t *grid) {
  assert (grid != NULL);

  choice_t *choice = calloc (1, sizeof (choice_t));
  if (choice == NULL) {
    return NULL;
  }

  choice->color = colors_full (grid->size);

  size_t min = grid->size;
  size_t count_color;

  for (size_t i = 0; i < grid->size; i++) {
    for (size_t j = 0; j < grid->size; j++) {

      if (!colors_is_singleton (grid->cells[i][j])) {

        count_color = colors_count (grid->cells[i][j]);
        if (count_color <= min) {
          choice->row = i;
          choice->column = j;
          choice->color = colors_random (grid->cells[i][j]);
          min = count_color;

          if (min == 2) {
            return choice;
          }
        }
      }
    }
  }
  return choice;
}
