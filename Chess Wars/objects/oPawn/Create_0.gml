cell_x = 0;
cell_y = 0;

// Pixel position for drawing
px = 0;
py = 0;

// Scale down the collision mask to match the cell size
mask_index = sprite_index;
image_xscale = CELL_SIZE / sprite_get_width(sprite_index);
image_yscale = CELL_SIZE / sprite_get_height(sprite_index);
