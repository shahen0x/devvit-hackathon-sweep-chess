/// @function piece_is_clicked()
/// @description Checks if the mouse is clicking on this piece's cell
/// @returns {Bool} True if the piece is being clicked
function piece_is_clicked()
{
    var piece_px = board.board_offset_x + cell_x * CELL_SIZE;
    var piece_py = board.board_offset_y + cell_y * CELL_SIZE;
    
    return point_in_rectangle(mouse_x, mouse_y, piece_px, piece_py, piece_px + CELL_SIZE, piece_py + CELL_SIZE);
}
