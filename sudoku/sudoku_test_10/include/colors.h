#ifndef COLORS_H
#define COLORS_H

#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>

#define MAX_COLORS 64

typedef uint64_t colors_t;

/* Initialise a color of size 'size' with a size set colors */
colors_t colors_full (const size_t size);

/* Initialize a color at 0 */
colors_t colors_empty (void);

/* Create a 'colors' with a single color set at the index 'color_id' */
colors_t colors_set (const size_t color_id);

/* Add to a 'colors' a single color set at the index 'color_id' */
colors_t colors_add (const colors_t colors, const size_t color_id);

/* Discard to a 'colors' a single color set at the index 'color_id' */
colors_t colors_discard (const colors_t colors, const size_t colors_id);

/* Check if a single color set 'color_id' is in 'colors' */
bool colors_is_in (const colors_t colors, const size_t color_id);

/* Return the complement set of the 'colors' */
colors_t colors_negate (const colors_t colors);

/* Return the intersection of the 'colors1' and 'colors2' */
colors_t colors_and (const colors_t colors1, const colors_t colors2);

/* Return the union of the 'colors1' and 'colors2' */
colors_t colors_or (const colors_t colors1, const colors_t colors2);

/* Return the exclusive union of the 'colors1' and 'colors2' */
colors_t colors_xor (const colors_t colors1, const colors_t colors2);

/* Return the 'colors1' private of 'colors2' */
colors_t colors_subtract (const colors_t colors1, const colors_t colors2);

/* Check if 'colors1' is included in 'colors2' */
bool colors_is_subset (const colors_t colors1, const colors_t colors2);

/* Check is a color a singleton */
bool colors_is_singleton (const colors_t colors);

/* Return the cardinal of the set 'colors' */
size_t colors_count (const colors_t colors);

/* Return the rightmost color of the set 'colors' */
colors_t colors_rightmost (const colors_t colors);

/* Return the leftmost color of the set 'colors' */
colors_t colors_leftmost (const colors_t colors);

/* Initialize random */
void prng_init (void);

/* Return a random color of the set 'colors' */
colors_t colors_random (const colors_t colors);

/* Return if 'colors1' is equal to 'colors2' */
bool colors_is_equal (const colors_t colors1, const colors_t colors2);

/* Check if a 'subgrid' of size 'size' is consistency*/
bool subgrid_consistency (colors_t *subgrid[], const size_t size);

/* Applies differents heuristics on the 'subgrid' of size 'size' */
bool subgrid_heuristics (colors_t *subgrid[], size_t size);

#endif /* COLORS_H */