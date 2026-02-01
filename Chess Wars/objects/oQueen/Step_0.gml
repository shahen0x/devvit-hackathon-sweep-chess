if (mouse_check_button_pressed(mb_left))
{
    // Get queen's pixel position
    var px = board.board_offset_x + cell_x * CELL_SIZE;
    var py = board.board_offset_y + cell_y * CELL_SIZE;
    
    // Check if mouse/touch is within the queen's bounds
    if (mouse_x >= px && mouse_x < px + CELL_SIZE &&
        mouse_y >= py && mouse_y < py + CELL_SIZE)
    {
        show_debug_message("Queen clicked on");
    }
}
