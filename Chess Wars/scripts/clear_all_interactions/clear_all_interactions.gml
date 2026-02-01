/// @function clear_all_interactions(exclude_instance)
/// @description Clears all button highlight states and piece selections
/// @param {Id.Instance} exclude_instance - Optional instance to exclude from clearing (use noone to clear all)
function clear_all_interactions(exclude_instance = noone)
{
    // Clear all button highlight states
    with (oButton)
    {
        highlight_mode = false;
    }
    
    // Clear all piece selections
    with (oQueen)
    {
        if (id != exclude_instance)
        {
            is_selected = false;
            valid_moves = [];
        }
    }
    with (oRook)
    {
        if (id != exclude_instance)
        {
            is_selected = false;
            valid_moves = [];
        }
    }
    with (oBishop)
    {
        if (id != exclude_instance)
        {
            is_selected = false;
            valid_moves = [];
        }
    }
    with (oKnight)
    {
        if (id != exclude_instance)
        {
            is_selected = false;
            valid_moves = [];
        }
    }
}
