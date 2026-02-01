// Clear all other button highlight states
with (oButton)
{
    highlight_mode = false;
}

// Clear all piece selections
with (oQueen) { is_selected = false; valid_moves = []; }
with (oRook) { is_selected = false; valid_moves = []; }
with (oBishop) { is_selected = false; valid_moves = []; }
with (oKnight) { is_selected = false; valid_moves = []; }

// Toggle highlight mode to show available cells
highlight_mode = !highlight_mode;
show_debug_message("Highlight mode: " + string(highlight_mode));