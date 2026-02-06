// Get reference to board instance
board = instance_find(oBoard, 0);

// Change desktop position
if (!global.is_mobile) {
	x = room_width / 2;
	y = (room_height / 2) + 120;
}
