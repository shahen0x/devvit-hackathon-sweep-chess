// Left Click event - Restart the game

// Get board instance
var board = instance_find(oBoard, 0);

// Only restart if board exists, game is over, and restart is enabled
if (instance_exists(oBoard) && board.game_over && board.restart_button_enabled) {
    // Restart the room
    room_restart();
}
