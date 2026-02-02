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
            
            // For pieces that use waypoints (like Knight), calculate the path
            if (use_waypoints)
            {
                waypoints = [];
                current_waypoint = 0;
                
                // Calculate direction to destination
                var dx = target_cell_x - cell_x;
                var dy = target_cell_y - cell_y;
                
                // Knight moves in L-shape: 2 squares in one direction, 1 in perpendicular
                // Determine if it's 2 horizontal + 1 vertical OR 2 vertical + 1 horizontal
                if (abs(dx) == 2)
                {
                    // Move 2 squares horizontally first, then 1 vertically
                    var step_x = sign(dx);
                    array_push(waypoints, [cell_x + step_x, cell_y]);      // First horizontal step
                    array_push(waypoints, [cell_x + step_x * 2, cell_y]);  // Second horizontal step
                    array_push(waypoints, [target_cell_x, target_cell_y]); // Final vertical step
                }
                else
                {
                    // Move 2 squares vertically first, then 1 horizontally
                    var step_y = sign(dy);
                    array_push(waypoints, [cell_x, cell_y + step_y]);      // First vertical step
                    array_push(waypoints, [cell_x, cell_y + step_y * 2]);  // Second vertical step
                    array_push(waypoints, [target_cell_x, target_cell_y]); // Final horizontal step
                }
            }
            
            // Deselect and clear valid moves
            is_selected = false;
            valid_moves = [];
            
            return true;
        }
    }
    
    return false;
}
