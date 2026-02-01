/// @function piece_try_move_to_cell()
/// @description Checks if a valid move cell was clicked and starts movement if so
/// @returns {Bool} True if movement was started
function piece_try_move_to_cell()
{
    if (!is_selected) return false;
    
    // Convert mouse position to cell coordinates
    var mouse_cell_x = (mouse_x - board.board_offset_x) div CELL_SIZE;
    var mouse_cell_y = (mouse_y - board.board_offset_y) div CELL_SIZE;
    
    for (var i = 0; i < array_length(valid_moves); i++)
    {
        var move = valid_moves[i];
        if (mouse_cell_x == move[0] && mouse_cell_y == move[1])
        {
            // Set target cell and start moving
            target_cell_x = move[0];
            target_cell_y = move[1];
            is_moving = true;
            
            // Deselect and clear valid moves
            is_selected = false;
            valid_moves = [];
            
            return true;
        }
    }
    
    return false;
}
