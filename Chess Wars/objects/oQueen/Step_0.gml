// Handle smooth movement
piece_handle_movement("Queen", true);

// Only allow clicks when not moving
if (!is_moving && mouse_check_button_pressed(mb_left))
{
    // Check if clicking on this piece - clear all interactions first
    if (piece_is_clicked())
    {
        clear_all_interactions(id);
    }
    
    // Check if mouse/touch is within the queen's bounds
    if (piece_is_clicked())
    {
        show_debug_message("Queen clicked on");
        
        // Toggle selection
        is_selected = !is_selected;
        
        if (is_selected)
        {
            // Calculate valid moves (horizontal, vertical, and diagonal)
            valid_moves = [];
            
            // Horizontal moves - Right
            for (var i = cell_x + 1; i < BOARD_SIZE; i++)
            {
                if (board.piece_positions[i][cell_y] == 1)
                    break;
                array_push(valid_moves, [i, cell_y]);
            }
            
            // Horizontal moves - Left
            for (var i = cell_x - 1; i >= 0; i--)
            {
                if (board.piece_positions[i][cell_y] == 1)
                    break;
                array_push(valid_moves, [i, cell_y]);
            }
            
            // Vertical moves - Down
            for (var j = cell_y + 1; j < BOARD_SIZE; j++)
            {
                if (board.piece_positions[cell_x][j] == 1)
                    break;
                array_push(valid_moves, [cell_x, j]);
            }
            
            // Vertical moves - Up
            for (var j = cell_y - 1; j >= 0; j--)
            {
                if (board.piece_positions[cell_x][j] == 1)
                    break;
                array_push(valid_moves, [cell_x, j]);
            }
            
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
            show_debug_message("Queen moving to: " + string(target_cell_x) + ", " + string(target_cell_y));
        }
    }
}
