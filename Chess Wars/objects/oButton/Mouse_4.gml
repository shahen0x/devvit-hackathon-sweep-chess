// Don't allow clicking if already used
if (used) exit;

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