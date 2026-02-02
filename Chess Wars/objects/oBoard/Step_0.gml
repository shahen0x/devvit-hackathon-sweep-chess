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

if (mouse_check_button_pressed(mb_left))
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

