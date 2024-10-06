#include "colors.h"

#include <stdio.h>
#include <unistd.h>

#include <math.h>
#include <time.h>

/************ COLORS_FULL ************/
colors_t colors_full (const size_t size) {
  return (size >= MAX_COLORS) ? -1ULL : (1ULL << size) - 1;
}

/************ COLORS_EMPTY ************/
colors_t colors_empty (void) { return 0; }

/************ COLORS_SET ************/
colors_t colors_set (const size_t color_id) {
  return (color_id >= MAX_COLORS) ? 0 : (1ULL << color_id);
}

/************ COLORS_ADD ************/
colors_t colors_add (const colors_t colors, const size_t color_id) {
  return colors | colors_set (color_id);
}

/************ COLORS_DISCARD ************/
colors_t colors_discard (const colors_t colors, const size_t color_id) {
  return (colors & ~colors_set (color_id));
}

/************ COLORS_IS_IN ************/
bool colors_is_in (const colors_t colors, const size_t color_id) {
  return ((colors & colors_set (color_id)) != 0);
}

/************ COLORS_NEGATE ************/
colors_t colors_negate (const colors_t colors) { return ~colors; }

/************ COLORS_AND ************/
colors_t colors_and (const colors_t colors1, const colors_t colors2) {
  return colors1 & colors2;
}

/************ COLORS_OR ************/
colors_t colors_or (const colors_t colors1, const colors_t colors2) {
  return colors1 | colors2;
}

/************ COLORS_XOR ************/
colors_t colors_xor (const colors_t colors1, const colors_t colors2) {
  return colors1 ^ colors2;
}

/************ COLORS_SUBTRACT ************/
colors_t colors_subtract (const colors_t colors1, const colors_t colors2) {
  return colors1 & ~colors2;
}

/************ COLORS_IS_SUBSET ************/
bool colors_is_subset (const colors_t colors1, const colors_t colors2) {
  return (colors1 & colors2) == colors1;
}

/************ COLORS_IS_SINGLETON ************/
bool colors_is_singleton (const colors_t colors) {
  return (colors & (colors - 1)) == 0 && colors != 0;
}

/************ COLORS_COUNT ************/
size_t colors_count (const colors_t colors) {
  /* Create masks */
  colors_t B5 = (1ULL << 32) - 1;
  colors_t B4 = B5 ^ (B5 << 16);
  colors_t B3 = B4 ^ (B4 << 8);
  colors_t B2 = B3 ^ (B3 << 4);
  colors_t B1 = B2 ^ (B2 << 2);
  colors_t B0 = B1 ^ (B1 << 1);

  /* Compute popcount */
  colors_t x = colors;
  x = ((x >> 1) & B0) + (x & B0);
  x = ((x >> 2) & B1) + (x & B1);
  x = ((x >> 4) + x) & B2;
  x = ((x >> 8) + x) & B3;
  x = ((x >> 16) + x) & B4;
  x = ((x >> 32) + x) & B5;

  return x;
}

/************ COLORS_RIGHTMOST ************/
colors_t colors_rightmost (const colors_t colors) { return colors & -colors; }

/************ COLORS_LEFTMOST ************/
colors_t colors_leftmost (const colors_t colors) {
  if (colors == 0) {
    return 0;
  }

  colors_t tmp_colors = colors;
  size_t count = 0;
  while ((tmp_colors >> 1) != 0) {
    tmp_colors >>= 1;
    count++;
  }

  return colors_set (count);
}

/************ PRNG_INIT ************/
void prng_init (void) {
  /* Initialization is done only once at first execution */
  static bool seed_initialized = false;
  if (!seed_initialized) {
    srand ((time (NULL) * getpid ()) % MAX_COLORS);
    seed_initialized = true;
  }
}

/************ COLORS_RANDOM ************/
colors_t colors_random (const colors_t colors) {
  if (colors == 0) {
    return 0;
  }

  prng_init ();
  size_t random_index = rand () % colors_count (colors);

  colors_t tmp_colors = colors;
  while (random_index > 0) {
    tmp_colors &= (tmp_colors - 1);
    random_index--;
  }

  return tmp_colors & -tmp_colors;
}

/************ COLORS_IS_EQUAL ************/
bool colors_is_equal (const colors_t colors1, const colors_t colors2) {
  return colors1 == colors2;
}

/************ SUBGRID_CONSISTENCY ************/
bool subgrid_consistency (colors_t *subgrid[], const size_t size) {
  colors_t all_colors = colors_empty ();
  colors_t all_singleton = 0;

  for (size_t i = 0; i < size; i++) {
    if (*subgrid[i] == 0) {
      return false;
    }

    if (colors_is_singleton (*subgrid[i])) {

      if (colors_is_subset (*subgrid[i], all_singleton)) {
        return false;
      }
      all_singleton = colors_or (all_singleton, *subgrid[i]);
    }

    all_colors = colors_or (all_colors, *subgrid[i]);
  }

  return colors_is_equal (all_colors, colors_full (size));
}

/************ HEURISTIC_CROSS_HATCHING ************/
static bool heuristics_cross_hatching (colors_t *subgrid[], size_t size) {
  colors_t all_singleton = colors_empty ();

  for (size_t i = 0; i < size; i++) {
    if (colors_is_singleton (*subgrid[i])) {
      all_singleton = colors_or (all_singleton, *subgrid[i]);
    }
  }

  bool change = false;
  for (size_t i = 0; i < size; i++) {
    if (!colors_is_singleton (*subgrid[i]) &&
        colors_and (all_singleton, *subgrid[i])) {
      *subgrid[i] = colors_subtract (*subgrid[i], all_singleton);
      change = true;
    }
  }

  return change;
}

/************ HEURISTIC_LONE_NUMBER ************/
static bool heuristics_lone_number (colors_t *subgrid[], size_t size) {
  colors_t first_appearance = colors_empty ();
  colors_t second_appearance = colors_empty ();
  colors_t intersection;

  for (size_t i = 0; i < size; i++) {
    intersection = colors_and (first_appearance, *subgrid[i]);
    first_appearance = colors_or (first_appearance, *subgrid[i]);
    second_appearance = colors_or (second_appearance, intersection);
  }

  colors_t lone_number = colors_subtract (first_appearance, second_appearance);
  if (lone_number == 0) {
    return false;
  }

  bool change = false;

  for (size_t i = 0; i < size; i++) {
    intersection = colors_and (*subgrid[i], lone_number);

    if (!colors_is_equal (intersection, colors_empty ()) &&
        !colors_is_equal (*subgrid[i], intersection)) {
      *subgrid[i] = intersection;
      change = true;
    }
  }
  return change;
}

/************ SUBGRID_HEURISTIC_NAKED_SUBSET ************/
bool heuristics_naked_subset (colors_t *subgrid[], size_t size) {

  bool change = false;

  for (size_t i = 0; i < size; i++) {
    colors_t colors_present = colors_empty ();

    if (!colors_is_singleton (*subgrid[i]) &&
        !colors_is_equal (*subgrid[i], colors_full (size))) {
      colors_present = colors_add (colors_present, i);

      for (size_t j = 0; j < size && colors_count (colors_present) <=
                                         colors_count (*subgrid[i]);
           j++) {
        if (colors_is_subset (*subgrid[j], *subgrid[i]))
          colors_present = colors_add (colors_present, j);
      }

      if (colors_count (colors_present) == colors_count (*subgrid[i])) {
        for (size_t j = 0; j < size; j++) {

          if (!colors_is_in (colors_present, j)) {
            colors_t tmp = *subgrid[j];
            *subgrid[j] = colors_subtract (*subgrid[j], *subgrid[i]);

            if (tmp != *subgrid[j]) {
              change = true;
            }
          }
        }
      }
    }
  }
  return change;
}

/************ SUBGRID_HEURISTIC_HIDDEN_SUBSET ************/
static bool heuristics_hidden_subset (colors_t *subgrid[], size_t size) {
  bool change = false;

  for (size_t i = 0; i < size; i++) {
    /* Number due to empiric test */
    /*if (colors_count (*subgrid[i]) >= size/2) {
      continue;
    }*/

    colors_t **cell_to_change = malloc (size * sizeof (colors_t *));
    size_t count = 0;
    size_t max_intersection = 0;
    size_t count_intersection;

    for (size_t i_subgrid = 0; i_subgrid < size; i_subgrid++) {
      colors_t intersection = colors_and (*subgrid[i], *subgrid[i_subgrid]);

      if (intersection != 0) {
        cell_to_change[count] = subgrid[i_subgrid];
        count++;
        count_intersection = colors_count (intersection);
        if (max_intersection < count_intersection) {
          max_intersection = count_intersection;
        }
      }
    }

    if (count == max_intersection) {
      for (size_t j = 0; j < count; j++) {
        colors_t new_color = colors_and (*cell_to_change[j], *subgrid[i]);
        if (!colors_is_equal (*cell_to_change[j], new_color)) {
          *cell_to_change[j] = new_color;
          change = true;
        }
      }
    }
    free (cell_to_change);
  }

  return change;
}

/************ SUBGRID_HEURISTICS ************/
bool subgrid_heuristics (colors_t *subgrid[], size_t size) {
  if (subgrid == NULL) {
    return false;
  }

  bool change = false;

  change = heuristics_cross_hatching (subgrid, size) || change;

  change = heuristics_lone_number (subgrid, size) || change;

  bool change2 = heuristics_naked_subset (subgrid, size);
  change = change || change2;

  if (!change2) {
    change = heuristics_hidden_subset (subgrid, size) || change;
  }

  return change;
}