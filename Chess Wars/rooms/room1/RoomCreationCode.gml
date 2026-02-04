// Detect mobile based on display orientation (height > width)
var is_mobile = display_get_height() > display_get_width();

if (is_mobile) {
    // Mobile: Keep default size (750x1168 - set in room properties)
    show_debug_message("Mobile detected - Using default room size 750x1168");
} else {
    // Desktop: Set room and window size to 1000x730
    var _width = 1000;
    var _height = 730;
    
    room_width = _width;
    room_height = _height;
    
    // Enable views if not already enabled
    view_enabled = true;
    view_visible[0] = true;
    
    // Update camera/view to match new room size
    var cam = view_camera[0];
    camera_set_view_size(cam, _width, _height);
    
    // Set view port to match window
    view_wport[0] = _width;
    view_hport[0] = _height;
    
    // Set GUI layer size
    display_set_gui_size(_width, _height);
    
    // Update surface size
    surface_resize(application_surface, _width, _height);
    
    // Update window size
    window_set_size(_width, _height);
    
    // Center the view at 0,0
    camera_set_view_pos(cam, 0, 0);
    
    // Recalculate board offsets for the new room size
    with (oBoard) {
        board_offset_x = (room_width - BOARD_SIZE * CELL_SIZE) div 2;
        board_offset_y = (room_height - BOARD_SIZE * CELL_SIZE) div 2;
        
        // Recalculate restart button position
        restart_button_x = room_width / 2 - 60;
        restart_button_y = room_height / 2 + 60;
        
        show_debug_message("Board offsets recalculated: x=" + string(board_offset_x) + " y=" + string(board_offset_y));
    }
    
    // Reposition all pieces based on new board offsets
    with (oPiece) {
        px = oBoard.board_offset_x + cell_x * CELL_SIZE;
        py = oBoard.board_offset_y + cell_y * CELL_SIZE;
        x = px;
        y = py;
    }
    
    // Reposition all pawns based on new board offsets
    with (oPawn) {
        px = oBoard.board_offset_x + cell_x * CELL_SIZE;
        py = oBoard.board_offset_y + cell_y * CELL_SIZE;
        x = px;
        y = py;
    }
    with (oBoard) {
        board_offset_x = (room_width - BOARD_SIZE * CELL_SIZE) div 2;
        board_offset_y = (room_height - BOARD_SIZE * CELL_SIZE) div 2;
        
        // Recalculate restart button position
        restart_button_x = room_width / 2 - 60;
        restart_button_y = room_height / 2 + 60;
        
        show_debug_message("Board offsets recalculated: x=" + string(board_offset_x) + " y=" + string(board_offset_y));
    }
    
    // Reposition all pieces based on new board offsets
    with (oPiece) {
        px = oBoard.board_offset_x + cell_x * CELL_SIZE;
        py = oBoard.board_offset_y + cell_y * CELL_SIZE;
        x = px;
        y = py;
    }
    
    // Reposition all pawns based on new board offsets
    with (oPawn) {
        px = oBoard.board_offset_x + cell_x * CELL_SIZE;
        py = oBoard.board_offset_y + cell_y * CELL_SIZE;
        x = px;
        y = py;
    }
    
    // Reposition all buttons based on new board offsets
    //with (oButton) {
    //    x = oBoard.board_offset_x + cell_x * CELL_SIZE;
    //    y = oBoard.board_offset_y + cell_y * CELL_SIZE;
    //}
    
    show_debug_message("Desktop detected - Room size set to " + string(_width) + "x" + string(_height));
}
