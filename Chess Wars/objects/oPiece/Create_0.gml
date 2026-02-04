// Common piece variables - inherited by all piece types

cell_x = 0;
cell_y = 0;

// Pixel position for smooth movement
px = 0;
py = 0;

// Track last cell for counting cells travelled
last_counted_cell_x = -1;
last_counted_cell_y = -1;

// Target cell for movement
target_cell_x = 0;
target_cell_y = 0;

// Waypoint system for multi-step movement (used by Knight)
waypoints = []; // Array of [cell_x, cell_y] waypoints
current_waypoint = 0;
use_waypoints = false; // Whether this piece moves through waypoints

// Movement state
is_moving = false;
move_speed = 16; // pixels per frame

// Selected state
is_selected = false;

// Array to store valid moves
valid_moves = [];

// Reference to the board (set when spawned)
board = noone;

// Piece name for debug messages (override in child objects)
piece_name = "Piece";

// Whether this piece captures during movement or only at destination
// (true for most pieces, false for Knight)
capture_during_move = true;

// Spawn animation variables
spawn_scale = 0;          // Current scale (starts at 0)
spawn_animating = true;   // Whether spawn animation is playing
spawn_speed = 0.15;       // How fast to animate (higher = faster)
