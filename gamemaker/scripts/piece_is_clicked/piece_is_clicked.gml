/// @function piece_is_clicked()
/// @description Checks if the mouse is clicking on this piece's cell
/// @returns {Bool} True if the piece is being clicked
function piece_is_clicked()
{
    var piece_px = board.board_offset_x + cell_x * global.cell_size;
    var piece_py = board.board_offset_y + cell_y * global.cell_size;
    
    return point_in_rectangle(mouse_x, mouse_y, piece_px, piece_py, piece_px + global.cell_size, piece_py + global.cell_size);
}
