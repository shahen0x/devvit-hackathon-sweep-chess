// Draw board border (filled rectangle behind the board)
var border_thickness = 4;
draw_set_color(#D9BE9E);
draw_rectangle(
    board_offset_x - border_thickness,
    board_offset_y - border_thickness,
    board_offset_x + BOARD_SIZE * CELL_SIZE + border_thickness - 1,
    board_offset_y + BOARD_SIZE * CELL_SIZE + border_thickness - 1,
    false  // filled
);

// Draw board cells on top
for (var hor = 0; hor < BOARD_SIZE; hor++)
{
    for (var vert = 0; vert < BOARD_SIZE; vert++)
    {
        // Custom chess board colors
        if ((hor + vert) mod 2 == 0)
            draw_set_color(#EDD6BB);  // Light beige/tan
        else
            draw_set_color(#D9BE9E);  // Dark tan/brown

        draw_rectangle(
			 board_offset_x + hor * CELL_SIZE,
             board_offset_y + vert * CELL_SIZE,
             board_offset_x + (hor + 1) * CELL_SIZE - 1,
             board_offset_y + (vert + 1) * CELL_SIZE - 1,
            false
        );
    }
}

draw_set_color(c_white);

// Draw stats UI
draw_set_font(arial_24);
draw_set_color(c_black);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_text(32, 32, "Moves: " + string(total_moves));
draw_text(32, 32 + 45, "Distance: " + string(cells_travelled_display));
