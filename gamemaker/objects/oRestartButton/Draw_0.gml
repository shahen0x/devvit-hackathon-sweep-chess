// Draw the restart button with appropriate alpha

// Get board instance
var board = instance_find(oBoard, 0);

// Set alpha based on whether button is enabled
if (instance_exists(oBoard) && board.restart_button_enabled) {
    image_alpha = 1.0;
} else {
    image_alpha = 0.5;
}

// Draw self
draw_self();
