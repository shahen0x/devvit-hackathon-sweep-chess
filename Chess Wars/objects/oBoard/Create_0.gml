board = array_create(BOARD_SIZE);
board_offset_x = (room_width - BOARD_SIZE * CELL_SIZE) div 2;
board_offset_y = (room_height - BOARD_SIZE * CELL_SIZE) div 2;

for (var hor = 0; hor < BOARD_SIZE; hor++)
{
    board[hor] = array_create(BOARD_SIZE);
    for (var vert = 0; vert < BOARD_SIZE; vert++)
    {
        board[hor][vert] = 0; // empty cell (you can store pieces later)
    }
}


// Spawn queen
queen = instance_create_layer(
    board_offset_x,
    board_offset_y,
    "Pieces",
    oQueen
);

queen.cell_x = 0;
queen.cell_y = 0;
queen.board = id;
queen.px = board_offset_x;
queen.py = board_offset_y;
queen.target_cell_x = 0;
queen.target_cell_y = 0;
show_debug_message("Queen instance: " + string(queen));

// Spawn pawn at cell (7,7)
pawn = instance_create_layer(
    board_offset_x + 7 * CELL_SIZE,
    board_offset_y + 7 * CELL_SIZE,
    "Pieces",
    oPawn
);

pawn.cell_x = 7;
pawn.cell_y = 7;
pawn.board = id;
pawn.px = board_offset_x + 7 * CELL_SIZE;
pawn.py = board_offset_y + 7 * CELL_SIZE;
show_debug_message("Pawn instance: " + string(pawn));

