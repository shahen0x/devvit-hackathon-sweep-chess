// pixel position on screen
var px = board.board_offset_x + cell_x * CELL_SIZE;
var py = board.board_offset_y + cell_y * CELL_SIZE;
// Draw a placeholder rectangle if no sprite
draw_set_color(c_purple);
draw_rectangle(px, py, px + CELL_SIZE, py + CELL_SIZE, false);
draw_set_color(c_white);
