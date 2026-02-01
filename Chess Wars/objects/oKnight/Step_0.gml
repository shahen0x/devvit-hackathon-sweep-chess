// Handle smooth movement (Knight captures only at destination, not during move)
piece_handle_movement("Knight", false);

// Only allow clicks when not moving
if (!is_moving && mouse_check_button_pressed(mb_left))
{
    // Check if clicking on this piece - clear all interactions first
    if (piece_is_clicked())
    {
        clear_all_interactions(id);
    }
    
    // Check if mouse/touch is within the knight's bounds
    if (piece_is_clicked())
    {
        show_debug_message("Knight clicked on");
        
        // Toggle selection
        is_selected = !is_selected;
        
        if (is_selected)
        {
            // Calculate valid moves (L-shaped: 2 squares in one direction, 1 in perpendicular)
            valid_moves = [];
            
            // All 8 possible L-shaped knight moves
            var knight_moves = [
                [2, 1],   // Right 2, Down 1
                [2, -1],  // Right 2, Up 1
                [-2, 1],  // Left 2, Down 1
                [-2, -1], // Left 2, Up 1
                [1, 2],   // Right 1, Down 2
                [1, -2],  // Right 1, Up 2
                [-1, 2],  // Left 1, Down 2
                [-1, -2]  // Left 1, Up 2
            ];
            
            for (var i = 0; i < array_length(knight_moves); i++)
            {
                var new_x = cell_x + knight_moves[i][0];
                var new_y = cell_y + knight_moves[i][1];
                
                // Check if move is within board bounds
                if (new_x >= 0 && new_x < BOARD_SIZE && new_y >= 0 && new_y < BOARD_SIZE)
                {
                    // Check if destination is not occupied by friendly pieces
                    if (board.piece_positions[new_x][new_y] == 0)
                    {
                        array_push(valid_moves, [new_x, new_y]);
                    }
                }
            }
        }
        else
        {
            // Clear valid moves when deselected
            valid_moves = [];
        }
    }
    // Check if clicked on a valid move cell
    else if (is_selected)
    {
        if (piece_try_move_to_cell())
        {
            show_debug_message("Knight moving to: " + string(target_cell_x) + ", " + string(target_cell_y));
        }
    }
}
