// Clear all interactions (buttons and pieces)
clear_all_interactions(noone);

// Toggle highlight mode to show available cells
highlight_mode = !highlight_mode;
show_debug_message("Highlight mode: " + string(highlight_mode));