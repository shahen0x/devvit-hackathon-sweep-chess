// Animate cells_travelled_display towards actual value
if (cells_travelled_display < cells_travelled)
{
    cells_counter_timer++;
    // Increment every 3 frames (slower = higher number)
    if (cells_counter_timer >= 4)
    {
        cells_travelled_display++;
        cells_counter_timer = 0;
    }
}
else
{
    cells_counter_timer = 0;
}

// Check for game over: all pawns dead (only check when no pieces are moving)
var any_piece_moving = false;
with (oPiece)
{
    if (is_moving)
    {
        any_piece_moving = true;
        break;
    }
}

if (!any_piece_moving && board_data_loaded)
{
    // Count remaining pawns
    var pawn_count = instance_number(oPawn);
    
    // Only trigger game over if player has made at least one move
    if (pawn_count == 0 && !game_over && total_moves > 0)
    {
        // Game Over!
        show_debug_message("GAME OVER - All pawns eliminated!");
        show_debug_message("Total Moves: " + string(total_moves));
        show_debug_message("Cells Travelled: " + string(cells_travelled));
        
        // Play win sound
        audio_play_sound(sndWin, 1, false);
        
        game_over = true;
        
        // Submit score to server (skip in test builds)
        if (is_test_build) {
            show_debug_message("Test build: skipping score submission.");
            score_submitted = true;
            score_submission_status = "success";
            restart_button_enabled = true;
        } else {
            api_submit_score(total_moves, cells_travelled, function(_http_status, _ok, _result, _payload) {
                show_debug_message("=== Score submission response ===");
                show_debug_message("HTTP Status: " + string(_http_status ?? "undefined"));
                show_debug_message("Success: " + string(_ok ?? "undefined"));
                show_debug_message("Result: " + string(_result ?? "undefined"));
                
                score_submitted = true;
                
                if (_ok && (_http_status == 200 || _http_status == 201)) {
                    score_submission_status = "success";
                    show_debug_message("Score submitted successfully!");
                } else {
                    score_submission_status = "failed";
                    show_debug_message("Failed to submit score.");
                }
                
                // Enable restart button after receiving response
                restart_button_enabled = true;
            });
        }
    }
}

// Handle restart button click during game over
if (game_over && restart_button_enabled && mouse_check_button_pressed(mb_left))
{
    var mx = mouse_x;
    var my = mouse_y;
    
    if (point_in_rectangle(mx, my, restart_button_x, restart_button_y, 
                          restart_button_x + restart_button_w, restart_button_y + restart_button_h))
    {
        room_restart();
    }
}

if (!game_over && mouse_check_button_pressed(mb_left))
{
    // Mouse position
    var mx = mouse_x;
    var my = mouse_y;

    // Convert to board-local space
    var local_x = mx - board_offset_x;
    var local_y = my - board_offset_y;

    // Bounds check on local coordinates first (must be within board area)
    if (local_x >= 0 && local_x < BOARD_SIZE * CELL_SIZE &&
        local_y >= 0 && local_y < BOARD_SIZE * CELL_SIZE)
    {
        // Convert to cell coordinates
        var cell_x = local_x div CELL_SIZE;
        var cell_y = local_y div CELL_SIZE;

        show_debug_message(
            "Tapped cell: " + string(cell_x) + ", " + string(cell_y)
        );
    }
}

