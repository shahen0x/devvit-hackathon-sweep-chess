// Handle smooth movement
piece_handle_movement();

// Block interactions if game is over
if (oBoard.game_over) exit;

// Check if any piece is moving (disable all interactions during movement)
var any_piece_moving = false;
with (oPiece)
{
    if (is_moving)
    {
        any_piece_moving = true;
        break;
    }
}

// Only allow clicks when not moving
if (!any_piece_moving && mouse_check_button_pressed(mb_left))
{
    // Check if clicking on this piece - clear all interactions first
    if (piece_is_clicked())
    {
        clear_all_interactions(id);
    }
    
    // Check if mouse/touch is within the rook's bounds
    if (piece_is_clicked())
    {
        show_debug_message("Rook clicked on");
        
        // Toggle selection
        is_selected = !is_selected;
        
        if (is_selected)
        {
            // Calculate valid moves (horizontal and vertical only, no diagonals)
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
