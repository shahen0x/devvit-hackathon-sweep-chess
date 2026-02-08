// Don't allow clicking if game is over
if (oBoard.game_over) exit;

// Don't allow clicking if board data hasn't loaded yet
if (!oBoard.board_data_loaded) exit;

// Don't allow clicking if already used
if (used) exit;

// Don't allow clicking if any piece is moving
with (oPiece)
{
    if (is_moving)
    {
        exit;
    }
}

// Save current state before clearing
var was_active = highlight_mode;

// Clear all interactions (buttons and pieces)
clear_all_interactions(noone);

// Only activate if it wasn't already active (toggle off if it was on)
if (!was_active)
{
    highlight_mode = true;
}
show_debug_message("Highlight mode: " + string(highlight_mode));