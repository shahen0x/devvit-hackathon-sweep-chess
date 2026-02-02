/// @function piece_handle_movement()
/// @description Handles smooth movement for a piece, including pawn capture
/// Uses instance variables: piece_name, capture_during_move, is_moving, board, etc.
function piece_handle_movement()
{
    if (!is_moving) return;
    
    // Determine target position based on waypoint system or direct movement
    var current_target_cell_x, current_target_cell_y;
    
    if (use_waypoints && array_length(waypoints) > 0)
    {
        // Move to current waypoint
        current_target_cell_x = waypoints[current_waypoint][0];
        current_target_cell_y = waypoints[current_waypoint][1];
    }
    else
    {
        // Direct movement to final target
        current_target_cell_x = target_cell_x;
        current_target_cell_y = target_cell_y;
    }
    
    // Calculate target pixel position
    var target_px = board.board_offset_x + current_target_cell_x * CELL_SIZE;
    var target_py = board.board_offset_y + current_target_cell_y * CELL_SIZE;
    
    // Move towards target
    var dist = point_distance(px, py, target_px, target_py);
    
    if (dist <= move_speed)
    {
        // Arrived at current waypoint/destination
        px = target_px;
        py = target_py;
        
        // Capture pawn at this position if capture_during_move is enabled
        if (capture_during_move)
        {
            var pawn_instance = instance_position(px + CELL_SIZE / 2, py + CELL_SIZE / 2, oPawn);
            if (pawn_instance != noone)
            {
                show_debug_message(piece_name + " captured pawn at waypoint!");
                audio_play_sound(sndKill, 1, false);
                instance_destroy(pawn_instance);
            }
        }
        
        // Check if using waypoints and not at final waypoint yet
        if (use_waypoints && array_length(waypoints) > 0 && current_waypoint < array_length(waypoints) - 1)
        {
            // Move to next waypoint
            current_waypoint++;
            show_debug_message(piece_name + " moving to waypoint " + string(current_waypoint));
        }
        else
        {
            // Arrived at final destination
            board.piece_positions[cell_x][cell_y] = 0; // Clear old position
            cell_x = target_cell_x;
            cell_y = target_cell_y;
            board.piece_positions[cell_x][cell_y] = 1; // Mark new position
            is_moving = false;
            
            // Reset last counted cell for next move
            last_counted_cell_x = -1;
            last_counted_cell_y = -1;
            
            // Clear waypoints
            waypoints = [];
            current_waypoint = 0;
            
            show_debug_message(piece_name + " arrived at: " + string(cell_x) + ", " + string(cell_y));
            
            // For pieces that don't capture during move: capture at destination only
            if (!capture_during_move)
            {
                var pawn_instance = instance_position(px + CELL_SIZE / 2, py + CELL_SIZE / 2, oPawn);
                if (pawn_instance != noone)
                {
                    show_debug_message(piece_name + " captured pawn!");
                    audio_play_sound(sndKill, 1, false);
                    instance_destroy(pawn_instance);
                }
            }
        }
    }
    else
    {
        // Move towards target
        var dir = point_direction(px, py, target_px, target_py);
        px += lengthdir_x(move_speed, dir);
        py += lengthdir_y(move_speed, dir);
        
        // Check for collision with pawns along the path (every frame while moving)
        if (capture_during_move)
        {
            var pawn_instance = instance_position(px + CELL_SIZE / 2, py + CELL_SIZE / 2, oPawn);
            if (pawn_instance != noone)
            {
                show_debug_message(piece_name + " captured pawn!");
                audio_play_sound(sndKill, 1, false);
                instance_destroy(pawn_instance);
            }
        }
    }
}
