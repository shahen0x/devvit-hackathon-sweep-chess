/// @function piece_handle_movement(piece_name)
/// @description Handles smooth movement for a piece, including pawn capture
/// @param {String} piece_name - Name of the piece for debug messages (e.g., "Queen", "Rook")
/// @param {Bool} capture_during_move - Whether to capture pawns during movement (false for Knight)
function piece_handle_movement(piece_name, capture_during_move = true)
{
    if (!is_moving) return;
    
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
        show_debug_message(piece_name + " arrived at: " + string(cell_x) + ", " + string(cell_y));
        
        // For Knight: capture at destination only
        if (!capture_during_move)
        {
            var pawn_instance = instance_position(px + CELL_SIZE / 2, py + CELL_SIZE / 2, oPawn);
            if (pawn_instance != noone)
            {
                show_debug_message(piece_name + " captured pawn!");
                instance_destroy(pawn_instance);
            }
        }
    }
    else
    {
        // Move towards target
        var dir = point_direction(px, py, target_px, target_py);
        px += lengthdir_x(move_speed, dir);
        py += lengthdir_y(move_speed, dir);
    }
    
    // Check for collision with pawns along the path (every frame while moving)
    if (capture_during_move)
    {
        var pawn_instance = instance_position(px + CELL_SIZE / 2, py + CELL_SIZE / 2, oPawn);
        if (pawn_instance != noone)
        {
            show_debug_message(piece_name + " captured pawn!");
            instance_destroy(pawn_instance);
        }
    }
}
