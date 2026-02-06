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
        
        // Only submit score to server for Reddit builds
        if (is_reddit_build()) {
            // Submit score to server
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
        } else {
            // Test build: Skip score submission, enable restart immediately
            show_debug_message("Test build - Skipping score submission");
            score_submitted = true;
            score_submission_status = "success";
            restart_button_enabled = true;
        }
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
    if (local_x >= 0 && local_x < BOARD_SIZE * global.cell_size &&
        local_y >= 0 && local_y < BOARD_SIZE * global.cell_size)
    {
        // Convert to cell coordinates
        var cell_x = local_x div global.cell_size;
        var cell_y = local_y div global.cell_size;

        show_debug_message(
            "Tapped cell: " + string(cell_x) + ", " + string(cell_y)
        );
    }
}

// === Cursor management: set cr_handpoint when hovering over interactive elements ===
var _hover_hand = false;

// 1. Check hovering over spawn buttons (oButton)
if (!_hover_hand)
{
    with (oButton)
    {
        if (!used && oBoard.board_data_loaded && !oBoard.game_over)
        {
            if (position_meeting(mouse_x, mouse_y, id))
            {
                _hover_hand = true;
                break;
            }
        }
    }
}

// 2. Check hovering over restart icon button
if (!_hover_hand && instance_exists(oRestartIconButton))
{
    with (oRestartIconButton)
    {
        if (position_meeting(mouse_x, mouse_y, id))
        {
            _hover_hand = true;
            break;
        }
    }
}

// 3. Check hovering over volume button
if (!_hover_hand && instance_exists(oVolumeButton))
{
    with (oVolumeButton)
    {
        if (position_meeting(mouse_x, mouse_y, id))
        {
            _hover_hand = true;
            break;
        }
    }
}

// 4. Check hovering over restart button (game over screen)
if (!_hover_hand && instance_exists(oRestartButton))
{
    with (oRestartButton)
    {
        if (instance_exists(oBoard) && oBoard.game_over && oBoard.restart_button_enabled)
        {
            if (position_meeting(mouse_x, mouse_y, id))
            {
                _hover_hand = true;
                break;
            }
        }
    }
}

// 5. Check hovering over pieces (only when game is active and no piece is moving)
if (!_hover_hand && !game_over && board_data_loaded)
{
    var _any_moving = false;
    with (oPiece)
    {
        if (is_moving) { _any_moving = true; break; }
    }
    
    if (!_any_moving)
    {
        with (oPiece)
        {
            var _piece_px = board.board_offset_x + self.cell_x * global.cell_size;
            var _piece_py = board.board_offset_y + self.cell_y * global.cell_size;
            if (point_in_rectangle(mouse_x, mouse_y, _piece_px, _piece_py, _piece_px + global.cell_size, _piece_py + global.cell_size))
            {
                _hover_hand = true;
                break;
            }
        }
    }
}

// 6. Check hovering over valid move cells (when a piece is selected)
if (!_hover_hand && !game_over)
{
    with (oPiece)
    {
        if (is_selected && array_length(valid_moves) > 0)
        {
            var _mx = mouse_x;
            var _my = mouse_y;
            var _local_x = _mx - board.board_offset_x;
            var _local_y = _my - board.board_offset_y;
            
            if (_local_x >= 0 && _local_x < BOARD_SIZE * global.cell_size &&
                _local_y >= 0 && _local_y < BOARD_SIZE * global.cell_size)
            {
                var _mcx = _local_x div global.cell_size;
                var _mcy = _local_y div global.cell_size;
                
                for (var _i = 0; _i < array_length(valid_moves); _i++)
                {
                    if (valid_moves[_i][0] == _mcx && valid_moves[_i][1] == _mcy)
                    {
                        _hover_hand = true;
                        break;
                    }
                }
            }
            if (_hover_hand) break;
        }
    }
}

// 7. Check hovering over valid spawn cells (when a button's highlight mode is active)
if (!_hover_hand && !game_over)
{
    var _any_highlight = false;
    var _highlight_piece = noone;
    with (oButton)
    {
        if (highlight_mode)
        {
            _any_highlight = true;
            _highlight_piece = piece_type;
            break;
        }
    }
    
    if (_any_highlight)
    {
        var _mx = mouse_x;
        var _my = mouse_y;
        var _local_x = _mx - board_offset_x;
        var _local_y = _my - board_offset_y;
        
        if (_local_x >= 0 && _local_x < BOARD_SIZE * global.cell_size &&
            _local_y >= 0 && _local_y < BOARD_SIZE * global.cell_size)
        {
            var _mcx = _local_x div global.cell_size;
            var _mcy = _local_y div global.cell_size;
            
            var _has_pawn = false;
            with (oPawn)
            {
                if (self.cell_x == _mcx && self.cell_y == _mcy) { _has_pawn = true; break; }
            }
            
            var _is_knight = (_highlight_piece == oKnight);
            var _can_spawn = (piece_positions[_mcx][_mcy] == 0) && (!_has_pawn || _is_knight);
            
            if (_can_spawn)
            {
                _hover_hand = true;
            }
        }
    }
}

// Apply cursor
if (_hover_hand)
{
    window_set_cursor(cr_handpoint);
}
else
{
    window_set_cursor(cr_default);
}

