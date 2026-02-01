// Handle smooth movement
if (is_moving)
{
    // Calculate target pixel position
    var target_px = board.board_offset_x + target_cell_x * CELL_SIZE;
    var target_py = board.board_offset_y + target_cell_y * CELL_SIZE;
    
    // Move towards target
    var dist = point_distance(px, py, target_px, target_py);
    
    if (dist <= move_speed)
    {
        // Arrived at destination
        px = target_px;
        py = target_py;
        cell_x = target_cell_x;
        cell_y = target_cell_y;
        is_moving = false;
        show_debug_message("Rook arrived at: " + string(cell_x) + ", " + string(cell_y));
    }
    else
    {
        // Move towards target
        var dir = point_direction(px, py, target_px, target_py);
        px += lengthdir_x(move_speed, dir);
        py += lengthdir_y(move_speed, dir);
    }
    
    // Check for collision with pawns along the path (every frame while moving)
    var pawn_instance = instance_position(px + CELL_SIZE / 2, py + CELL_SIZE / 2, oPawn);
    if (pawn_instance != noone)
    {
        show_debug_message("Rook captured pawn!");
        instance_destroy(pawn_instance);
    }
}

// Only allow clicks when not moving
if (!is_moving && mouse_check_button_pressed(mb_left))
{
    // Convert mouse position to cell coordinates
    var mouse_cell_x = (mouse_x - board.board_offset_x) div CELL_SIZE;
    var mouse_cell_y = (mouse_y - board.board_offset_y) div CELL_SIZE;
    
    // Get rook's pixel position based on current cell
    var rook_px = board.board_offset_x + cell_x * CELL_SIZE;
    var rook_py = board.board_offset_y + cell_y * CELL_SIZE;
    
    // Check if mouse/touch is within the rook's bounds
    if (mouse_x >= rook_px && mouse_x < rook_px + CELL_SIZE &&
        mouse_y >= rook_py && mouse_y < rook_py + CELL_SIZE)
    {
        show_debug_message("Rook clicked on");
        
        // Toggle selection
        is_selected = !is_selected;
        
        if (is_selected)
        {
            // Calculate valid moves (horizontal and vertical only, no diagonals)
            valid_moves = [];
            
            // Horizontal moves (left and right)
            for (var i = 0; i < BOARD_SIZE; i++)
            {
                if (i != cell_x)
                {
                    array_push(valid_moves, [i, cell_y]);
                }
            }
            
            // Vertical moves (up and down)
            for (var j = 0; j < BOARD_SIZE; j++)
            {
                if (j != cell_y)
                {
                    array_push(valid_moves, [cell_x, j]);
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
                
                show_debug_message("Rook moving to: " + string(target_cell_x) + ", " + string(target_cell_y));
                break;
            }
        }
    }
}
