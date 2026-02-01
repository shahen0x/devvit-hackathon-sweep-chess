// Handle smooth movement
piece_handle_movement();

// Only allow clicks when not moving
if (!is_moving && mouse_check_button_pressed(mb_left))
{
    // Check if clicking on this piece - clear all interactions first
    if (piece_is_clicked())
    {
        clear_all_interactions(id);
    }
    
    // Check if mouse/touch is within the bishop's bounds
    if (piece_is_clicked())
    {
        show_debug_message("Bishop clicked on");
        
        // Toggle selection
        is_selected = !is_selected;
        
        if (is_selected)
        {
            // Calculate valid moves (diagonal only)
            valid_moves = [];
            
            // Diagonal moves (all 4 directions)
            // Top-left diagonal
            var dx = cell_x - 1;
            var dy = cell_y - 1;
            while (dx >= 0 && dy >= 0)
            {
                if (board.piece_positions[dx][dy] == 1)
                    break;
                array_push(valid_moves, [dx, dy]);
                dx--;
                dy--;
            }
            
            // Top-right diagonal
            dx = cell_x + 1;
            dy = cell_y - 1;
            while (dx < BOARD_SIZE && dy >= 0)
            {
                if (board.piece_positions[dx][dy] == 1)
                    break;
                array_push(valid_moves, [dx, dy]);
                dx++;
                dy--;
            }
            
            // Bottom-left diagonal
            dx = cell_x - 1;
            dy = cell_y + 1;
            while (dx >= 0 && dy < BOARD_SIZE)
            {
                if (board.piece_positions[dx][dy] == 1)
                    break;
                array_push(valid_moves, [dx, dy]);
                dx--;
                dy++;
            }
            
            // Bottom-right diagonal
            dx = cell_x + 1;
            dy = cell_y + 1;
            while (dx < BOARD_SIZE && dy < BOARD_SIZE)
            {
                if (board.piece_positions[dx][dy] == 1)
                    break;
                array_push(valid_moves, [dx, dy]);
                dx++;
                dy++;
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
            show_debug_message(piece_name + " moving to: " + string(target_cell_x) + ", " + string(target_cell_y));
        }
    }
}
