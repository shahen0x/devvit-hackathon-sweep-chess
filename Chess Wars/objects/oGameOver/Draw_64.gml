// Draw GUI event - Game Over screen

// Only draw if game is over
if (!board.game_over) {
    exit;
}

// Disable layers
layer_set_visible("UI", false);
layer_set_visible("Pieces", false);
layer_set_visible("Instances", false);
layer_set_visible("GameOverUI", true);

// Game Over text
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_font(arial_24);

var center_x = room_width / 2;
var center_y = room_height / 2;

// Draw moves and distance with black color
draw_set_color(c_black);
draw_text(center_x, center_y - 35, "Moves: " + string(board.total_moves));
draw_text(center_x, center_y + 10, "Distance: " + string(board.cells_travelled));
draw_set_color(c_white);

// Display score submission status
var msg = "Submitting score...";
if (!board.score_submitted) {
    draw_set_color(c_black);
} else if (board.score_submission_status == "success") {
    draw_set_color(#d93900);
	msg = "Score submitted successfully!"
} else if (board.score_submission_status == "failed") {
	msg = "Failed to submit score"
    draw_set_color(c_red);
}

draw_set_font(arial_small);
draw_text(center_x, center_y + 200, msg);
draw_set_color(c_white);


// Reset alignment
draw_set_halign(fa_left);
draw_set_valign(fa_top);
