// Draw GUI event - always draws on top of everything

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

// Reset all pawn alphas to 1.0 first
with (oPawn)
{
    image_alpha = 1.0;
}

// Draw highlight overlay for valid spawn cells
if (any_highlight_mode)
{
    var is_knight_selected = (highlight_piece_type == oKnight);
    
    // Set all pawns to a lower alpha when in highlight mode (for all pieces)
    with (oPawn)
    {
        image_alpha = 0.3;
    }
    
    draw_set_alpha(VALID_MOVE_CIRCLE_ALPHA);
    draw_set_color(c_white);
    
    for (var hor = 0; hor < BOARD_SIZE; hor++)
    {
        for (var vert = 0; vert < BOARD_SIZE; vert++)
        {
			draw_set_alpha(1);
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
                var cx = board_offset_x + hor * global.cell_size + global.cell_size / 2;
                var cy = board_offset_y + vert * global.cell_size + global.cell_size / 2;
                var cell_x_pos = board_offset_x + hor * global.cell_size;
                var cell_y_pos = board_offset_y + vert * global.cell_size;
                
                // If no pawn -> draw white circle, else draw sPawnDanger sprite
                if (!has_pawn) {
                    var sprite_size = global.cell_size / 3.8;
                    var offset_x = (global.cell_size - sprite_size) / 2;
                    var offset_y = (global.cell_size - sprite_size) / 2;
                    draw_sprite_stretched(sSpawnPoint, 0, cell_x_pos + offset_x, cell_y_pos + offset_y, sprite_size, sprite_size);
                } else {
					draw_set_alpha(1.0)
                    draw_sprite_stretched(sPawnDanger, 0, cell_x_pos, cell_y_pos, global.cell_size, global.cell_size);
                }
            }
        }
    }
    
    draw_set_alpha(1.0);
}
