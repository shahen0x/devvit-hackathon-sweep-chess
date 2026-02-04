// Draw board border (filled rectangle behind the board)
var border_thickness = 4;
draw_set_color(#D9BE9E);
draw_rectangle(
    board_offset_x - border_thickness,
    board_offset_y - border_thickness,
    board_offset_x + BOARD_SIZE * CELL_SIZE + border_thickness - 1,
    board_offset_y + BOARD_SIZE * CELL_SIZE + border_thickness - 1,
    false  // filled
);

// Draw board cells on top
for (var hor = 0; hor < BOARD_SIZE; hor++)
{
    for (var vert = 0; vert < BOARD_SIZE; vert++)
    {
        // Custom chess board colors
        if ((hor + vert) mod 2 == 0)
            draw_set_color(#EDD6BB);  // Light beige/tan
        else
            draw_set_color(#D9BE9E);  // Dark tan/brown

        draw_rectangle(
			 board_offset_x + hor * CELL_SIZE,
             board_offset_y + vert * CELL_SIZE,
             board_offset_x + (hor + 1) * CELL_SIZE - 1,
             board_offset_y + (vert + 1) * CELL_SIZE - 1,
            false
        );
    }
}

draw_set_color(c_white);

// Check if any button has highlight mode active and which piece type
var any_highlight_mode = false;
var highlight_piece_type = noone;
with (oButton)
{
    if (highlight_mode)
    {
        any_highlight_mode = true;
        highlight_piece_type = piece_type;
        break;
    }
}

// Draw highlight overlay for free cells if any button's highlight mode is active
if (any_highlight_mode)
{
    var is_knight_selected = (highlight_piece_type == oKnight);
    
    for (var hor = 0; hor < BOARD_SIZE; hor++)
    {
        for (var vert = 0; vert < BOARD_SIZE; vert++)
        {
            // Check if cell has a pawn
            var has_pawn = false;
            with (oPawn)
            {
                if (cell_x == hor && cell_y == vert)
                {
                    has_pawn = true;
                    break;
                }
            }
            
            // Knight can spawn on pawns, other pieces need empty cells
            var is_valid = (piece_positions[hor][vert] == 0) && 
                           (!has_pawn || is_knight_selected);
            
            if (is_valid)
            {
                draw_set_alpha(0.5);
                // Use different color for pawn cells (knight only)
                if (has_pawn && is_knight_selected)
                {
                    draw_set_color(c_red); // Red for cells where knight will kill pawn
                }
                else
                {
                    draw_set_color(c_lime); // Green for empty cells
                }
                
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
