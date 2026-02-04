// Draw valid move highlights if selected
if (is_selected && array_length(valid_moves) > 0)
{
    draw_set_alpha(0.5);
    
    for (var i = 0; i < array_length(valid_moves); i++)
    {
        var move = valid_moves[i];
        var hx = board.board_offset_x + move[0] * CELL_SIZE;
        var hy = board.board_offset_y + move[1] * CELL_SIZE;
        
        // Check if there's a pawn at this cell
        var has_pawn = false;
        with (oPawn)
        {
            if (cell_x == move[0] && cell_y == move[1])
            {
                has_pawn = true;
                break;
            }
        }
        
        // Red for cells with pawns, green for empty
        draw_set_color(has_pawn ? c_red : c_lime);
        draw_rectangle(hx, hy, hx + CELL_SIZE, hy + CELL_SIZE, false);
    }
    
    draw_set_alpha(1.0);
}

// Draw the rook sprite if assigned, otherwise draw a placeholder
if (sprite_index != -1)
{
    // Animate spawn scale
    if (spawn_animating)
    {
        spawn_scale += spawn_speed;
        if (spawn_scale >= 1)
        {
            spawn_scale = 1;
            spawn_animating = false;
        }
    }
    
    // Draw 144x144 sprite stretched to fit CELL_SIZE with spawn animation
    draw_set_color(c_white);
    draw_set_alpha(1);
    
    // Calculate scaled size for spawn animation
    var scaled_size = CELL_SIZE * spawn_scale * 0.9;
    var offset = (CELL_SIZE - scaled_size) / 2;
    
    draw_sprite_stretched(sprite_index, image_index, px + offset, py + offset, scaled_size, scaled_size);
}
else
{
    // Draw placeholder rectangle for rook
    draw_set_color(c_blue);
    draw_rectangle(px, py, px + CELL_SIZE, py + CELL_SIZE, false);
    draw_set_color(c_white);
}
