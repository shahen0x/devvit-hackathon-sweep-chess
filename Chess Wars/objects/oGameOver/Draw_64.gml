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
draw_set_color(c_white);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

var center_x = room_width / 2;
var center_y = room_height / 2;

draw_text(center_x, center_y - 80, "GAME OVER");
draw_text(center_x, center_y - 40, "All Pawns Eliminated!");
draw_text(center_x, center_y, "Final Moves: " + string(board.total_moves));
draw_text(center_x, center_y + 20, "Cells Travelled: " + string(board.cells_travelled));

// Display score submission status
if (!board.score_submitted) {
    draw_set_color(c_yellow);
    draw_text(center_x, center_y + 40, "Submitting score...");
    draw_set_color(c_white);
} else if (board.score_submission_status == "success") {
    draw_set_color(c_lime);
    draw_text(center_x, center_y + 40, "Score submitted successfully!");
    draw_set_color(c_white);
} else if (board.score_submission_status == "failed") {
    draw_set_color(c_red);
    draw_text(center_x, center_y + 40, "Failed to submit score");
    draw_set_color(c_white);
}

// Reset alignment
draw_set_halign(fa_left);
draw_set_valign(fa_top);
