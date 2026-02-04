board = array_create(BOARD_SIZE);
board_offset_x = (room_width - BOARD_SIZE * CELL_SIZE) div 2;
board_offset_y = (room_height - BOARD_SIZE * CELL_SIZE) div 2;

// Stats tracking
total_moves = 0;        // Increments each time player chooses to move a piece
cells_travelled = 0;    // Increments for each cell a piece passes through
cells_travelled_display = 0;  // For animated UI display, counts up to cells_travelled
cells_counter_timer = 0;      // Timer for slowing down display animation

// Game over state
game_over = false;
board_data_loaded = false;  // Flag to track when board data has been received
restart_button_x = room_width / 2 - 60;
restart_button_y = room_height / 2 + 60;
restart_button_w = 120;
restart_button_h = 40;

// Score submission state
score_submitted = false;
score_submission_status = "";  // "success", "failed", or ""
restart_button_enabled = false;

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

// Spawn random pawns (COMMENTED OUT - now using server data)
/*
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
*/

// Fetch board data from server
api_get_board_data(function(_http_status, _ok, _result, _payload) {
	show_debug_message("=== Board data received from server ===");
	show_debug_message("HTTP Status: " + string(_http_status ?? "undefined"));
	show_debug_message("Success: " + string(_ok ?? "undefined"));
	show_debug_message("Result: " + string(_result ?? "undefined"));
	
	// Try to parse the result as JSON
	if (_ok && !is_undefined(_result) && _result != "") {
		try {
			var _data = json_parse(_result);
			show_debug_message("Parsed data: " + json_stringify(_data));
			
			// Spawn pawns from server board data
			// board[x][y] where board[x] is the column array, y is the row index
			// board[x][y] === 1 means there's a pawn at that position
			if (variable_struct_exists(_data, "board") && is_array(_data.board)) {
				var _board = _data.board;
				var _board_ref = oBoard.id; // Store reference to oBoard
				
				for (var _x = 0; _x < array_length(_board); _x++) {
					if (is_array(_board[_x])) {
						for (var _y = 0; _y < array_length(_board[_x]); _y++) {
							if (_board[_x][_y] == 1) {
								// Spawn a pawn at this position
							// Invert y: board y=0 should be at bottom (screen y=7), y=7 at top (screen y=0)
							var _screen_y = 7 - _y;
							var new_pawn = instance_create_layer(
								_board_ref.board_offset_x + _x * CELL_SIZE,
								_board_ref.board_offset_y + _screen_y * CELL_SIZE,
								"Pieces",
								oPawn
							);
							
							new_pawn.cell_x = _x;
							new_pawn.cell_y = _screen_y;
							new_pawn.board = _board_ref;
							new_pawn.px = _board_ref.board_offset_x + _x * CELL_SIZE;
							new_pawn.py = _board_ref.board_offset_y + _screen_y * CELL_SIZE;
							show_debug_message("Pawn spawned from server at: " + string(_x) + "," + string(_screen_y));
							}
						}
					}
				}
			}
			// Mark board data as loaded after processing
			_board_ref.board_data_loaded = true;
			show_debug_message("Board data loaded successfully!");
		} catch(_ex) {
			show_debug_message("Failed to parse JSON: " + string(_ex));
		}
	}
});