// Draw the pawn sprite if assigned, otherwise draw a placeholder
if (sprite_index != -1)
{
    draw_sprite(sprite_index, image_index, px, py);
}
else
{
    // Draw placeholder circle for pawn
    draw_set_color(c_yellow);
    draw_circle(px + CELL_SIZE / 2, py + CELL_SIZE / 2, CELL_SIZE / 3, false);
    draw_set_color(c_white);
}
