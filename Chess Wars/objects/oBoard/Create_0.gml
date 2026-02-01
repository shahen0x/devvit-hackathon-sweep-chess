board = array_create(BOARD_SIZE);
board_offset_x = (room_width - BOARD_SIZE * CELL_SIZE) div 2;
board_offset_y = (room_height - BOARD_SIZE * CELL_SIZE) div 2;

// Initialize random seed based on today's date
//var seed = current_year * 10000 + current_month * 100 + current_day;
//random_set_seed(seed);
//show_debug_message("Random seed (date): " + string(seed));
randomize();

for (var hor = 0; hor < BOARD_SIZE; hor++)
{
    board[hor] = array_create(BOARD_SIZE);
    for (var vert = 0; vert < BOARD_SIZE; vert++)
    {
        board[hor][vert] = 0; // 0 = empty, 1 = piece (queen/rook/bishop/knight)
    }
}

// Track piece positions (1 = has piece, 0 = empty)
piece_positions = array_create(BOARD_SIZE);
for (var i = 0; i < BOARD_SIZE; i++)
{
    piece_positions[i] = array_create(BOARD_SIZE);
    for (var j = 0; j < BOARD_SIZE; j++)
    {
        piece_positions[i][j] = 0;
    }
}


// Spawn queen
//queen = instance_create_layer(
//    board_offset_x,
//    board_offset_y,
//    "Pieces",
//    oQueen
//);

//queen.cell_x = 0;
//queen.cell_y = 0;
//queen.board = id;
//queen.px = board_offset_x;
//queen.py = board_offset_y;
//queen.target_cell_x = 0;
//queen.target_cell_y = 0;
//piece_positions[0][0] = 1; // Mark queen position
//show_debug_message("Queen instance: " + string(queen));

//// Spawn rook next to queen at cell (1,0)
//rook = instance_create_layer(
//    board_offset_x + 1 * CELL_SIZE,
//    board_offset_y,
//    "Pieces",
//    oRook
//);

//rook.cell_x = 1;
//rook.cell_y = 0;
//rook.board = id;
//rook.px = board_offset_x + 1 * CELL_SIZE;
//rook.py = board_offset_y;
//rook.target_cell_x = 1;
//rook.target_cell_y = 0;
//piece_positions[1][0] = 1; // Mark rook position
//show_debug_message("Rook instance: " + string(rook));

//// Spawn bishop next to rook at cell (2,0)
//bishop = instance_create_layer(
//    board_offset_x + 2 * CELL_SIZE,
//    board_offset_y,
//    "Pieces",
//    oBishop
//);

//bishop.cell_x = 2;
//bishop.cell_y = 0;
//bishop.board = id;
//bishop.px = board_offset_x + 2 * CELL_SIZE;
//bishop.py = board_offset_y;
//bishop.target_cell_x = 2;
//bishop.target_cell_y = 0;
//piece_positions[2][0] = 1; // Mark bishop position
//show_debug_message("Bishop instance: " + string(bishop));

//// Spawn knight next to bishop at cell (3,0)
//knight = instance_create_layer(
//    board_offset_x + 3 * CELL_SIZE,
//    board_offset_y,
//    "Pieces",
//    oKnight
//);

//knight.cell_x = 3;
//knight.cell_y = 0;
//knight.board = id;
//knight.px = board_offset_x + 3 * CELL_SIZE;
//knight.py = board_offset_y;
//knight.target_cell_x = 3;
//knight.target_cell_y = 0;
//piece_positions[3][0] = 1; // Mark knight position
//show_debug_message("Knight instance: " + string(knight));

// Spawn random pawns
var num_pawns = 16; // Change this number to spawn more/fewer pawns
var occupied_cells = ds_map_create(); // Track occupied cells
occupied_cells[? "0,0"] = true; // Queen's position
occupied_cells[? "1,0"] = true; // Rook's position
occupied_cells[? "2,0"] = true; // Bishop's position
occupied_cells[? "3,0"] = true; // Knight's position

for (var i = 0; i < num_pawns; i++)
{
    var attempts = 0;
    var found_spot = false;
    var spawn_x, spawn_y;
    
    // Try to find an empty cell (max 100 attempts)
    while (attempts < 100 && !found_spot)
    {
        spawn_x = irandom(BOARD_SIZE - 1);
        spawn_y = irandom(BOARD_SIZE - 1);
        var key = string(spawn_x) + "," + string(spawn_y);
        
        if (!ds_map_exists(occupied_cells, key))
        {
            found_spot = true;
            occupied_cells[? key] = true;
        }
        attempts++;
    }
    
    if (found_spot)
    {
        var new_pawn = instance_create_layer(
            board_offset_x + spawn_x * CELL_SIZE,
            board_offset_y + spawn_y * CELL_SIZE,
            "Pieces",
            oPawn
        );
        
        new_pawn.cell_x = spawn_x;
        new_pawn.cell_y = spawn_y;
        new_pawn.board = id;
        new_pawn.px = board_offset_x + spawn_x * CELL_SIZE;
        new_pawn.py = board_offset_y + spawn_y * CELL_SIZE;
        show_debug_message("Pawn " + string(i) + " spawned at: " + string(spawn_x) + "," + string(spawn_y));
    }
}

ds_map_destroy(occupied_cells);

