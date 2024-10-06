#include "sudoku.h"

#include "grid.h"

#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#include "/home/thomas/Application/klee_with_uclibc/klee/include/klee/klee.h"
#include <err.h>
#include <getopt.h>
#include <math.h>
#include <string.h>
#include <time.h>

typedef enum { mode_first, mode_all, mode_generate, mode_unique } mode_type;

static bool verbose = false;
static bool error = false;
static size_t fill_ratio = 0;
static size_t nb_choice = 0;
static size_t nb_backtrack = 0;
static size_t nb_sol = 0;
static clock_t clock_debut;

/************ FILE_PARSER ************/
static grid_t *file_parser (char *filename) {
  FILE *input_file = fopen (filename, "r+");
  if (input_file == NULL) {
    warnx ("error : the file cannot be opened correctly\n");
    goto error;
  }

  char first_row[MAX_GRID_SIZE];
  size_t size = MAX_GRID_SIZE;
  size_t row = 0;
  size_t column = 0;
  bool commentary = false;
  grid_t *grid = NULL;
  size_t nb_fill = 0;

  int c = fgetc (input_file);
  if (c == EOF) {
    warnx ("warning : '%s' : empty file\n", filename);
    goto error;
  }

  while (c != EOF) {
    switch (c) {
    case ' ':

    case '\t':
      break;

    case '#':
      commentary = true;
      break;

    case '\n':
      commentary = false;

      /* Creating the grid and adding the first line */
      if (row == 0 && !commentary && column != 0) {
        size = column;
        if (!grid_check_size (size)) {
          warnx ("warning : '%s' : invalid size of grid\n", filename);
          goto error;
        }

        grid = grid_alloc (size);
        if (grid == NULL) {
          warnx ("warning : '%s' : allocation of the grid failed\n", filename);
          goto error;
        }

        for (size_t i = 0; i < size; i++) {
          if (!grid_check_char (grid, first_row[i])) {
            warnx ("warning : '%s' : wrong character '%c' at line 1\n",
                   filename, first_row[i]);
            goto error_free;
          }
          grid_set_cell (grid, 0, i, first_row[i]);

          if (first_row[i] != '_') {
            nb_fill++;
          }
        }
      }

      if (row != 0 && column != size && column != 0) {
        warnx ("warning : '%s' : line %li is malformed! (wrong number of "
               "columns)\n",
               filename, row + 1);
        goto error_free;
      }

      if (column != 0) {
        column = 0;
        row += 1;
      }
      break;

    default:
      if (commentary) {
        break;
      }

      if (grid != NULL && !grid_check_char (grid, c)) {
        warnx ("warning : '%s' : wrong character '%c' at line %li\n", filename,
               c, row + 1);
        goto error_free;
      }

      if (row == size) {
        warnx ("warning : '%s' : grid has additional line!\n", filename);
        goto error_free;
      }

      if (column == size) {
        warnx ("warning : '%s' : line %li is malformed! (wrong number of "
               "columns)\n",
               filename, row + 1);
        goto error_free;
      }

      if (grid == NULL) {
        first_row[column] = c;
        column++;

      } else {
        grid_set_cell (grid, row, column, c);

        if (c != '_') {
          nb_fill++;
        }

        column++;
      }
    }
    c = fgetc (input_file);
  }

  /* Case if size = 1 and file with no '\n */
  if (row == 0 && column == 1) {
    size = 1;
    grid = grid_alloc (size);

    if (!grid_check_char (grid, first_row[0])) {
      warnx ("warning : '%s' : wrong character '%c' at line 1\n", filename,
             first_row[0]);
      goto error_free;
    }

    grid_set_cell (grid, 0, 0, first_row[0]);

    if (first_row[0] != '_') {
      nb_fill++;
    }

    size_t size_full = grid_get_size (grid) * grid_get_size (grid);
    fill_ratio = round (100 * nb_fill / size_full);

    fclose (input_file);
    return grid;
  }

  /* Case if EOF with non '\n' */
  if (column == size && row == size - 1) {
    size_t size_full = grid_get_size (grid) * grid_get_size (grid);
    fill_ratio = round (100 * nb_fill / size_full);

    fclose (input_file);
    return grid;
  }

  if (column != 0) {
    warnx ("warning : '%s' : line %li is malformed! (wrong number of "
           "columns)\n",
           filename, row + 1);
    goto error_free;
  }

  if (grid == NULL) {
    warnx ("warning : '%s' : file with no sudoku\n", filename);
    goto error_free;
  }

  if (row != size) {
    warnx ("warning : '%s' : grid has %li missing line(s)!\n", filename,
           size - row);
    goto error_free;
  }

  size_t size_full = grid_get_size (grid) * grid_get_size (grid);
  fill_ratio = 100 * nb_fill / size_full;

  fclose (input_file);
  return grid;

/* Error handling */
error_free:
  grid_free (grid);

error:
  error = true;
  fclose (input_file);
  return NULL;
}

/************ GRID_BACKTRACK ************/
static grid_t *grid_backtrack (grid_t *grid, mode_type mode,
                               FILE *output_file) {
  double temps_ecoule = ((double)(clock () - clock_debut)) / CLOCKS_PER_SEC;
  /* Number due to empiric test */
  if (mode == mode_generate && temps_ecoule >= 20.0) {
    return grid;
  }
  if (!grid_is_consistent (grid)) {
    return NULL;
  }

  status_t status = grid_heuristic (grid);
  if ((mode == mode_first || mode == mode_generate) && status == grid_solved) {
    return grid;
  }

  if (mode == mode_all && status == grid_solved) {
    nb_sol = nb_sol + 1;
    fprintf (output_file, "# Solution #%li\n", nb_sol);
    grid_print (grid, output_file);
    return NULL;
  }

  if (mode == mode_unique && status == grid_solved) {
    nb_sol = nb_sol + 1;

    if (nb_sol >= 2) {
      return grid;
    }

    return NULL;
  }

  prng_init ();
  choice_t *choice = grid_choice (grid);

  if (choice == NULL || grid_choice_is_empty (*choice)) {
    free (choice);
    return NULL;
  }
  nb_choice++;

  grid_t *copy = grid_copy (grid);

  grid_choice_apply (copy, *choice);

  grid_t *grid_returned = grid_backtrack (copy, mode, output_file);
  nb_backtrack++;

  if ((mode == mode_first || mode == mode_generate) && grid_returned != NULL) {
    if (grid_returned != copy) {
      grid_free (copy);
    }

    free (choice);
    return grid_returned;
  }

  grid_free (copy);
  grid_free (grid_returned);

  grid_choice_discard (grid, *choice);
  free (choice);

  nb_backtrack++;
  return grid_backtrack (grid, mode, output_file);
}

/************ GRID_SOLVER ************/
static grid_t *grid_solver (grid_t *grid, const mode_type mode,
                            FILE *output_file) {
  if (grid == NULL) {
    return NULL;
  }

  nb_sol = 0;

  grid_t *grid_final = grid_backtrack (grid, mode, output_file);
  if (mode == mode_all && nb_sol == 0) {
    fprintf (output_file, "The grid hasn't been solved !\n"
                          "The initial grid isn't consistent!\n\n");
    error = true;
    return NULL;
  }

  if (mode == mode_all) {
    if (grid != grid_final) {
      free (grid_final);
    }
    return NULL;
  }

  return grid_final;
}

/************ GRID_GENERATE ************/
grid_t *grid_generate (size_t size, bool unique) {
  grid_t *grid = grid_alloc (size);
  if (grid == NULL) {
    return NULL;
  }

  for (size_t row = 0; row < size; row++) {
    for (size_t column = 0; column < size; column++) {
      grid_set_cell (grid, row, column, colors_full (size));
    }
  }

  prng_init ();
  size_t sqrt_size = sqrt (grid_get_size (grid));

  /* Fill the first block*/
  for (size_t row = 0; row < sqrt_size; row++) {
    for (size_t column = 0; column < sqrt_size; column++) {
      grid_set_cell_random (grid, row, column);
      grid_heuristic (grid);
    }
  }

  /* Fill the first row and column */
  for (size_t i = 0; i < grid_get_size (grid); i++) {
    grid_set_cell_random (grid, 0, i);
    grid_set_cell_random (grid, i, 0);
    grid_heuristic (grid);
  }

  grid_t *return_grid = NULL;
  bool test;
  do {
    if (return_grid != NULL) {
      grid_free (return_grid);
    }

    clock_debut = clock ();
    grid_t *grid_tmp = grid_copy (grid);

    return_grid = grid_backtrack (grid_tmp, mode_generate, stdout);

    if (grid_tmp != return_grid) {
      grid_free (grid_tmp);
    }

    test = false;
    if (return_grid != NULL) {
      test = grid_is_solved (return_grid) && grid_is_consistent (return_grid);
    }
  } while (!test);

  if (return_grid != grid) {
    grid_free (grid);
  }

  /* Select random cell to clear */
  size_t full_size = size * size;
  size_t nb_empty_cell = full_size - full_size * FILLED_RATIO;

  size_t i = 0;
  size_t rand_index;
  size_t row;
  size_t column;

  while (i <= nb_empty_cell) {
    rand_index = rand () % full_size;
    row = rand_index / size;
    column = rand_index % size;

    colors_t tmp = grid_get_cell_colors (return_grid, row, column);

    if (colors_is_singleton (tmp)) {
      grid_set_cell (return_grid, row, column, colors_full (size));
      i++;
    }
    if (unique) {
      nb_sol = 0;
      grid_t *grid_test = grid_copy (return_grid);
      grid_t *tmp_grid = grid_backtrack (grid_test, mode_unique, stdout);

      if (tmp_grid != grid_test) {
        grid_free (tmp_grid);
      }
      grid_free (grid_test);

      if (nb_sol >= 2) {
        grid_set_cell_colors (return_grid, row, column, tmp);
        i--;
      }
    }
  }

  return return_grid;
}

/************ USAGE ************/
void usage () {
  printf ("Usage: sudoku [-a|-o FILE|-v|-V|-h] FILE...\n"
          "       sudoku -g[SIZE] [-u|-o FILE|-v|-V|inputFile-h]\n"
          "Solve or generate Sudoku grids of size: 1, 4, 9, 16, 25, 36, 49, "
          "64\n\n"
          "-a,--all                search for all possible solutions\n"
          "-g[N],--generate[=N]    generate a grid of size NxN (default: 9)\n"
          "-o FILE,--outpout FILE  write output to FILE\n"
          "-u,--unique             generate a grid with unique solution\n"
          "-v,--verbose            verbose output\n"
          "-V,--version            display version and exit\n"
          "-h,--help               display this help and exit\n");
}

/************ MAIN ************/
int main (int argc, char *argv[]) {
  int input_size = 39;
  char *input[input_size];
  input[0] = "-a";
  input[1] = "-g";
  input[2] = "-g1";
  input[3] = "-g2";
  input[4] = "-g3";
  input[5] = "-g4";
  input[6] = "-u";
  input[7] = "-v";
  input[8] = "-V";
  input[9] = "-h";
  input[10] = "../test/grid-parser/grid-00-empty_file-fail.sku";
  input[11] = "../test/grid-parser/grid-09-unknown_char_l1_c1-fail.sku";
  input[12] = "../test/grid-parser/grid-10-unknown_char_l7_c12-fail.sku";
  input[13] = "../test/grid-parser/grid-11-missing_char_l9-fail.sku";
  input[14] = "../test/grid-parser/grid-12-extra_char_l10-fail.sku";
  input[15] = "../test/grid-parser/grid-13-missing_line-fail.sku";
  input[16] = "../test/grid-parser/grid-14-extra_line-fail.sku";
  input[17] = "../test/grid-parser/grid-15-empty_line-pass.sku";
  input[18] = "../test/grid-parser/grid-16-whole_line_commented_out-pass.sku";
  input[19] = "../test/grid-parser/grid-17-end_with_EOF_no_endofline-pass.sku";
  input[20] =
      "../test/grid-parser/grid-18-size_1_end_with_EOF_no_endofline-pass.sku";
  input[21] =
      "../test/grid-parser/grid-19-start_with_comment_and_empty_line-pass.sku";
  input[22] = "../test/grid-parser/grid-20-size_17-fail.sku";
  input[23] = "../test/grid-parser/grid-21-commented_char_l4-fail.sku";
  input[24] = "../test/grid-parser/grid-22-comment_at_last_line-pass.sku";
  input[25] =
      "../test/grid-parser/grid-23-missing_char_with_EOF_no_endofline-fail.sku";
  input[26] = "../test/grid-parser/grid-24-only_a_comment_no_grid-fail.sku";
  input[27] =
      "../test/grid-parser/"
      "grid-25-only_a_comment_grid_end_with_no_endofline_before_EOF-fail.sku";
  input[28] =
      "../test/grid-parser/grid-26-random_number_of_spaces_tabs-pass.sku";
  input[29] = "../test/grid-parser/grid-27-wrong_char_on_first_line-fail.sku";
  input[30] = "../test/grid-parser/"
              "grid-28-size_1_with_EOF_no_endofline_and_wrong_char-fail.sku";
  input[31] = "../test/grid-solver/grid-01x01-01.sku";
  input[32] =
      "../test/grid-solver/grid-16x16-06-twice_char_8_in_line-inconsistent.sku";
  input[33] = "../test/grid-solver/grid-04x04-01.sku";
  input[34] = "../test/grid-solver/"
              "grid-16x16-07-twice_char_A_in_columns-inconsistent.sku";
  input[35] = "../test/grid-solver/grid-04x04-02.sku";
  input[36] = "../test/grid-solver/"
              "grid-16x16-08-twice_char_B_in_a_block-inconsistent.sku";
  input[37] = "../test/grid-solver/grid-09x09-02.sku";
  input[38] = "../test/grid-solver/grid-36x36-03-inconsistent.sku";


  int new_argc = klee_range (3, 5, "new_argc");

  int tab[4];
  for (int i = 1; i < new_argc - 1; i++) {
    tab[i] = klee_range (1, 9, "tab");
  }
  tab[new_argc - 1] = klee_range (10, input_size, "file");

  char *new_argv[5];
  for (int i = 1; i < new_argc; i++) {
    new_argv[i] = input[tab[i]];
  }

  mode_type mode = mode_first;
  bool unique = false;
  int size_grid = 0;

  /* Check the different option entry by the user */
  int optc;
  char *name_output_file = NULL;
  FILE *output_file = stdout;

  const char *short_opts = "ao:uvVhg::";
  const struct option lopt[] = {{"help", no_argument, NULL, 'h'},
                                {"all", no_argument, NULL, 'a'},
                                {"generate", optional_argument, NULL, 'g'},
                                {"output", required_argument, NULL, 'o'},
                                {"unique", no_argument, NULL, 'u'},
                                {"verbose", no_argument, NULL, 'v'},
                                {"version", no_argument, NULL, 'V'},
                                {NULL, 0, NULL, 0}};

  while ((optc = getopt_long (new_argc, new_argv, short_opts, lopt, NULL)) !=
         -1) {
    switch (optc) {
    case 'a':
      mode = mode_all;
      break;

    case 'g':
      if (!optarg) {
        size_grid = DEFAULT_SIZE;
        break;
      }
      size_grid = atoi (optarg);
      if (size_grid == 0) {
        errx (EXIT_FAILURE,
              "error : the argument pass to the option 'generate' is not an "
              "integer\n");
      }
      if (!grid_check_size (size_grid)) {
        errx (EXIT_FAILURE, "error : invalid size of grid\n");
      }
      break;

    case 'o':
      name_output_file = optarg;
      break;

    case 'u':
      unique = true;
      break;

    case 'V':
      printf ("sudoku %i.%i.%i\n", VERSION, REVISION, SUBVERSION);
      printf ("Solve/generate sudoku grids of size: 1, 4, 9, 16, 25, 36, 49, "
              "64\n");
      return EXIT_SUCCESS;

    case 'v':
      verbose = true;
      break;

    case 'h':
      usage ();
      return EXIT_SUCCESS;

    default:
      errx (EXIT_FAILURE, "error: invalid option '%s'!\n",
            new_argv[optind - 1]);
    }
  }

  /*Test if we are in solver with no file*/
  if (new_argc - optind == 0 && size_grid == 0) {
    errx (EXIT_FAILURE, "error : no input grid given !\n");
  }

  /*Check if different option are in conflict*/
  if (size_grid != 0 && mode == mode_all) {
    warnx (
        "warning : option 'all' conflict with generate mode, disabling it !");
  }

  if (size_grid == 0 && unique) {
    warnx ("warning : option 'unique' conflict with solver mode, disabling "
           "it !");
  }

  /*Test if the files are readable*/
  for (int i = optind; i < new_argc; i++) {
    if (new_argv[i] == NULL || access (new_argv[i], R_OK) != 0) {
      errx (EXIT_FAILURE, "error : the file %s is not readable\n", new_argv[i]);
    }
  }

  /* Generate a grid */
  if (size_grid != 0) {
    grid_t *grid = grid_generate (size_grid, unique);
    grid_print (grid, output_file);
    grid_free (grid);
  }

  /*Solve the grid*/
  if (name_output_file != NULL) {
    output_file = fopen (name_output_file, "w+");
    if (output_file == NULL) {
      errx (EXIT_FAILURE, "error : the file cannot be opened correctly\n");
    }
  }

  for (int i = optind; i < new_argc; i++) {
    /* Reset global variable*/
    fill_ratio = 0;
    nb_choice = 0;
    nb_backtrack = 0;
    nb_sol = 0;

    fprintf (output_file, "# Solving '%s'...\n\n", new_argv[i]);
    grid_t *grid = file_parser (new_argv[i]);

    if (grid != NULL) {
      if (verbose) {
        fprintf (output_file, "# Initial grid:\n");
        grid_print (grid, output_file);
      }

      grid_t *grid_solve = grid_solver (grid, mode, output_file);

      if (mode == mode_first) {
        status_t status = grid_heuristic (grid_solve);

        if (status == grid_solved) {
          fprintf (output_file, "# Solution:\n");
          grid_print (grid_solve, output_file);
        }

        if (status == grid_inconsistent) {
          fprintf (output_file, "The grid hasn't been solved !\n");
          fprintf (output_file, "The initial grid isn't consistent!\n\n");
          error = true;
        }

        if (grid != grid_solve) {
          grid_free (grid_solve);
        }
      }

      grid_free (grid);

      if (verbose) {
        fprintf (output_file,
                 "# Statistics for the current run\n"
                 "# Initial fill ratio: %li%%\n"
                 "# Number of choices: %li\n"
                 "# Number of backtracks: %li\n",
                 fill_ratio, nb_choice, nb_backtrack);

        if (mode == mode_first) {
          fprintf (output_file, "\n");
        }
      }

      if (mode == mode_all) {
        fprintf (output_file, "# Number of solutions: %li\n\n", nb_sol);
      }
    }
  }

  if (output_file != stdout) {
    fclose (output_file);
  }

  return (!error) ? EXIT_SUCCESS : EXIT_FAILURE;
}