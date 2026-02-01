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
        board.piece_positions[cell_x][cell_y] = 0; // Clear old position
        px = target_px;
        py = target_py;
        cell_x = target_cell_x;
        cell_y = target_cell_y;
        board.piece_positions[cell_x][cell_y] = 1; // Mark new position
        is_moving = false;
        show_debug_message("Knight arrived at: " + string(cell_x) + ", " + string(cell_y));
        
        // Knight only captures at destination (jumps over pieces)
        var pawn_instance = instance_position(px + CELL_SIZE / 2, py + CELL_SIZE / 2, oPawn);
        if (pawn_instance != noone)
        {
            show_debug_message("Knight captured pawn!");
            instance_destroy(pawn_instance);
        }
    }
    else
    {
        // Move towards target
        var dir = point_direction(px, py, target_px, target_py);
        px += lengthdir_x(move_speed, dir);
        py += lengthdir_y(move_speed, dir);
    }
}

// Only allow clicks when not moving
if (!is_moving && mouse_check_button_pressed(mb_left))
{
    // Convert mouse position to cell coordinates
    var mouse_cell_x = (mouse_x - board.board_offset_x) div CELL_SIZE;
    var mouse_cell_y = (mouse_y - board.board_offset_y) div CELL_SIZE;
    
    // Get knight's pixel position based on current cell
    var knight_px = board.board_offset_x + cell_x * CELL_SIZE;
    var knight_py = board.board_offset_y + cell_y * CELL_SIZE;
    
    // Check if mouse/touch is within the knight's bounds
    if (mouse_x >= knight_px && mouse_x < knight_px + CELL_SIZE &&
        mouse_y >= knight_py && mouse_y < knight_py + CELL_SIZE)
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
                
                show_debug_message("Knight moving to: " + string(target_cell_x) + ", " + string(target_cell_y));
                break;
            }
        }
    }
}
