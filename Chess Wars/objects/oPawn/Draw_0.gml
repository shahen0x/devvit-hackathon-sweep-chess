// Draw the pawn sprite if assigned, otherwise draw a placeholder
if (sprite_index != -1)
{
    draw_set_color(c_white);  // Ensure no color tinting is applied to sprite
    draw_set_alpha(image_alpha);  // Use image_alpha instead of hardcoded 1
    // Draw 144x144 sprite stretched to fit CELL_SIZE
    draw_sprite_stretched(sprite_index, image_index, px, py, CELL_SIZE, CELL_SIZE);
    draw_set_alpha(1);  // Reset for other drawing
}
else
{
    // Draw placeholder circle for pawn
    draw_set_color(c_yellow);
    draw_circle(px + CELL_SIZE / 2, py + CELL_SIZE / 2, CELL_SIZE / 3, false);
    draw_set_color(c_white);
}
