// Draw GUI event - draws on top of everything

// Draw valid move highlights if selected
if (is_selected && array_length(valid_moves) > 0)
{
    draw_set_alpha(VALID_MOVE_CIRCLE_ALPHA);
    
    for (var i = 0; i < array_length(valid_moves); i++)
    {
        var move = valid_moves[i];
        var cx = board.board_offset_x + move[0] * CELL_SIZE + CELL_SIZE / 2;
        var cy = board.board_offset_y + move[1] * CELL_SIZE + CELL_SIZE / 2;
        var cell_x_pos = board.board_offset_x + move[0] * CELL_SIZE;
        var cell_y_pos = board.board_offset_y + move[1] * CELL_SIZE;
        
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
        
        // If no pawn -> draw white circle, else draw sPawnDanger sprite
        if (!has_pawn) {
            draw_set_color(c_white);
            draw_circle(cx, cy, VALID_MOVE_CIRCLE_RADIUS, false);
        } else {
            draw_set_alpha(1.0);
            draw_sprite_stretched(sPawnDanger, 0, cell_x_pos, cell_y_pos, CELL_SIZE, CELL_SIZE);
        }
    }
    
    draw_set_alpha(1.0);
}
