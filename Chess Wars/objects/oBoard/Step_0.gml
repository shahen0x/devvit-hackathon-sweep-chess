if (mouse_check_button_pressed(mb_left))
{
    // Mouse position
    var mx = mouse_x;
    var my = mouse_y;

    // Convert to board-local space
    var local_x = mx - board_offset_x;
    var local_y = my - board_offset_y;

    // Convert to cell coordinates
    var cell_x = local_x div CELL_SIZE;
    var cell_y = local_y div CELL_SIZE;

    // Bounds check
    if (cell_x >= 0 && cell_x < BOARD_SIZE &&
        cell_y >= 0 && cell_y < BOARD_SIZE)
    {
        show_debug_message(
            "Tapped cell: " + string(cell_x) + ", " + string(cell_y)
        );
    }
}

