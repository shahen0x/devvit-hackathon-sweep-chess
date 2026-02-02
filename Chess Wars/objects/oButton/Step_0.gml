// Block interactions if game is over
if (oBoard.game_over) exit;

// Handle cell selection when highlight mode is active
if (highlight_mode && mouse_check_button_pressed(mb_left))
{
    // Mouse position
    var mx = mouse_x;
    var my = mouse_y;

    // Convert to board-local space
    var local_x = mx - oBoard.board_offset_x;
    var local_y = my - oBoard.board_offset_y;

    // Bounds check on local coordinates first (must be within board area)
    if (local_x >= 0 && local_x < BOARD_SIZE * CELL_SIZE &&
        local_y >= 0 && local_y < BOARD_SIZE * CELL_SIZE)
    {
        // Convert to cell coordinates
        var cell_x = local_x div CELL_SIZE;
        var cell_y = local_y div CELL_SIZE;
        // Check if there's a pawn at this cell
        var has_pawn = false;
        with (oPawn)
        {
            if (self.cell_x == cell_x && self.cell_y == cell_y)
            {
                has_pawn = true;
                break;
            }
        }
        
        // Check if cell is free (no piece and no pawn)
        if (oBoard.piece_positions[cell_x][cell_y] == 0 && !has_pawn)
        {
            // Spawn piece at the selected cell
            var new_piece = instance_create_layer(
                oBoard.board_offset_x + cell_x * CELL_SIZE,
                oBoard.board_offset_y + cell_y * CELL_SIZE,
                "Pieces",
                piece_type
            );
            
            new_piece.cell_x = cell_x;
            new_piece.cell_y = cell_y;
            new_piece.board = oBoard.id;
            new_piece.px = oBoard.board_offset_x + cell_x * CELL_SIZE;
            new_piece.py = oBoard.board_offset_y + cell_y * CELL_SIZE;
            new_piece.target_cell_x = cell_x;
            new_piece.target_cell_y = cell_y;
            
            // Notify oBoard that a piece was created at this square
            oBoard.piece_positions[cell_x][cell_y] = 1;
            
            show_debug_message(object_get_name(piece_type) + " spawned at cell: " + string(cell_x) + ", " + string(cell_y));
            
            // Turn off highlight mode after spawning
            highlight_mode = false;
            
            // Mark button as used
            used = true;
        }
    }
}