for (var hor = 0; hor < BOARD_SIZE; hor++)
{
    for (var vert = 0; vert < BOARD_SIZE; vert++)
    {
        // Normal alternating colors
        if ((hor + vert) mod 2 == 0)
            draw_set_color(c_white);
        else
            draw_set_color(c_black);

        draw_rectangle(
            //hor * CELL_SIZE,
            //vert * CELL_SIZE,
            //hor * CELL_SIZE + CELL_SIZE,
            //vert * CELL_SIZE + CELL_SIZE,
			 board_offset_x + hor * CELL_SIZE,
             board_offset_y + vert * CELL_SIZE,
             board_offset_x + hor * CELL_SIZE + CELL_SIZE,
             board_offset_y + vert * CELL_SIZE + CELL_SIZE,
            false
        );
    }
}

draw_set_color(c_white);

// Check if any button has highlight mode active
var any_highlight_mode = false;
with (oButton)
{
    if (highlight_mode)
    {
        any_highlight_mode = true;
        break;
    }
}

// Draw highlight overlay for free cells if any button's highlight mode is active
if (any_highlight_mode)
{
    draw_set_alpha(0.5);
    draw_set_color(c_lime);
    
    for (var hor = 0; hor < BOARD_SIZE; hor++)
    {
        for (var vert = 0; vert < BOARD_SIZE; vert++)
        {
            // Check if cell is free (no piece and no pawn)
            var has_pawn = false;
            with (oPawn)
            {
                if (cell_x == hor && cell_y == vert)
                {
                    has_pawn = true;
                    break;
                }
            }
            
            if (piece_positions[hor][vert] == 0 && !has_pawn)
            {
                draw_rectangle(
                    board_offset_x + hor * CELL_SIZE,
                    board_offset_y + vert * CELL_SIZE,
                    board_offset_x + hor * CELL_SIZE + CELL_SIZE,
                    board_offset_y + vert * CELL_SIZE + CELL_SIZE,
                    false
                );
            }
        }
    }
    
    draw_set_alpha(1.0);
    draw_set_color(c_white);
}

// Draw stats UI
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_text(8, 8, "Moves: " + string(total_moves));
draw_text(8, 28, "Cells Travelled: " + string(cells_travelled_display));
