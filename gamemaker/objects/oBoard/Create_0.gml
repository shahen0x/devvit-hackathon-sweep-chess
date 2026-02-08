// Visual debug log for mobile (can't see console there)
global.debug_logs = [];
global.max_debug_logs = 15; // Keep last 15 messages

/// @func debug_log(msg)
/// @param {String} msg The message to log
function debug_log(msg) {
	show_debug_message(msg);
	array_push(global.debug_logs, string(msg));
	if (array_length(global.debug_logs) > global.max_debug_logs) {
		array_delete(global.debug_logs, 0, 1);
	}
}

//debug_log("=== Game Starting ===");
//debug_log("Mobile: " + string(global.is_mobile));
//debug_log("OS: " + string(os_type));

// Log os_get_info keys for debugging
var _info = os_get_info();
var _keys = ds_map_keys_to_array(_info);
//debug_log("os_info keys: " + string(array_length(_keys)));
//for (var _k = 0; _k < min(5, array_length(_keys)); _k++) {
//	debug_log("  " + string(_keys[_k]));
//}
ds_map_destroy(_info);

board = array_create(BOARD_SIZE);

board_offset_x = (room_width - BOARD_SIZE * global.cell_size) div 2 + global.board_left_padding;
board_offset_y = ((room_height - BOARD_SIZE * global.cell_size) div 2) + global.board_top_padding;

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


// Initialize global board cache if it doesn't exist
if (!variable_global_exists("cached_board_data")) {
	global.cached_board_data = undefined;
	global.board_cache_valid = false;
	global.board_cache_timestamp = undefined;
}

// Check if this is a Reddit build or test build
if (is_reddit_build()) {
	// REDDIT BUILD: Use cached data if available, otherwise fetch from server
	if (is_board_cache_valid()) {
		debug_log("Reddit build - Using cached board data...");
		spawn_pawns_from_data(get_cached_board_data());
		board_data_loaded = true;
		debug_log("Board loaded from cache!");
	} else {
		debug_log("Reddit build - Fetching fresh board data...");
		debug_log("URL: " + reddit_get_base_url());
		debug_log("Token: " + reddit_get_token());

		api_get_board_data(function(_http_status, _ok, _result, _payload) {
			debug_log("=== Response ===");
			debug_log("HTTP: " + string(_http_status ?? "undef"));
			debug_log("OK: " + string(_ok ?? "undef"));
			debug_log("Len: " + string(string_length(_result ?? "")));
			
			// Try to parse the result as JSON
			if (_ok && !is_undefined(_result) && _result != "") {
				try {
					var _data = json_parse(_result);
					debug_log("JSON parsed OK");
					
					// Cache the board data for future restarts
					cache_board_data(_data);
					
					// Spawn pawns from server board data
					spawn_pawns_from_data(_data);
					
					// Mark board data as loaded after processing
					oBoard.board_data_loaded = true;
					debug_log("Board loaded!");
				} catch(_ex) {
					debug_log("JSON Error: " + string(_ex));
				}
			} else {
				debug_log("Fetch failed or empty");
				debug_log("_ok=" + string(_ok));
			}
		});
	}
} else {
	// TEST BUILD: Spawn random pawns locally
	debug_log("Test build detected - Spawning random pawns...");
	
	var num_pawns = 24; // Change this number to spawn more/fewer pawns
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
				board_offset_x + spawn_x * global.cell_size,
				board_offset_y + spawn_y * global.cell_size,
				"Pieces",
				oPawn
			);
			
			new_pawn.cell_x = spawn_x;
			new_pawn.cell_y = spawn_y;
			new_pawn.board = id;
			new_pawn.px = board_offset_x + spawn_x * global.cell_size;
			new_pawn.py = board_offset_y + spawn_y * global.cell_size;
			//debug_log("Pawn " + string(i) + " spawned at: " + string(spawn_x) + "," + string(spawn_y));
		}
	}
	
	ds_map_destroy(occupied_cells);
	
	// Mark board as loaded immediately for test build
	board_data_loaded = true;
	debug_log("Test board loaded!");
}

/// @func spawn_pawns_from_data(data)
/// @param {Struct} data The board data containing pawn positions
function spawn_pawns_from_data(_data) {
	// Spawn pawns from board data
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
							_board_ref.board_offset_x + _x * global.cell_size,
							_board_ref.board_offset_y + _screen_y * global.cell_size,
							"Pieces",
							oPawn
						);
						
						new_pawn.cell_x = _x;
						new_pawn.cell_y = _screen_y;
						new_pawn.board = _board_ref;
						new_pawn.px = _board_ref.board_offset_x + _x * global.cell_size;
						new_pawn.py = _board_ref.board_offset_y + _screen_y * global.cell_size;
						//debug_log("Pawn at: " + string(_x) + "," + string(_screen_y));
					}
				}
			}
		}
	}
}