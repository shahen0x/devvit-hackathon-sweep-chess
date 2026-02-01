// Draw valid move highlights if selected
if (is_selected && array_length(valid_moves) > 0)
{
    draw_set_alpha(0.5);
    draw_set_color(c_lime);
    
    for (var i = 0; i < array_length(valid_moves); i++)
    {
        var move = valid_moves[i];
        var hx = board.board_offset_x + move[0] * CELL_SIZE;
        var hy = board.board_offset_y + move[1] * CELL_SIZE;
        draw_rectangle(hx, hy, hx + CELL_SIZE, hy + CELL_SIZE, false);
    }
    
    draw_set_alpha(1.0);
}

// Draw the bishop sprite if assigned, otherwise draw a placeholder
if (sprite_index != -1)
{
    draw_sprite(sprite_index, image_index, px, py);
}
else
{
    // Draw placeholder rectangle for bishop
    draw_set_color(c_green);
    draw_rectangle(px, py, px + CELL_SIZE, py + CELL_SIZE, false);
    draw_set_color(c_white);
}
