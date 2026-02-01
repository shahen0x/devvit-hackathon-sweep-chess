for (var hor = 0; hor < BOARD_SIZE; hor++)
{
    for (var vert = 0; vert < BOARD_SIZE; vert++)
    {
        // Alternate colors
        if ((hor + vert) mod 2 == 0)
            draw_set_color(c_white);
        else
            draw_set_color(c_black);

        draw_rectangle(
            //hor * CELL_SIZE,
            //vert * CELL_SIZE,
            //hor * CELL_SIZE + CELL_SIZE,
            //vert * CELL_SIZE + CELL_SIZE,
			 board_offset_x + hor * CELL_SIZE,
             board_offset_y + vert * CELL_SIZE,
             board_offset_x + hor * CELL_SIZE + CELL_SIZE,
             board_offset_y + vert * CELL_SIZE + CELL_SIZE,
            false
        );
    }
}

draw_set_color(c_white);
