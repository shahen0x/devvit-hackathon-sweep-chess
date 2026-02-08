// Draw button at reduced alpha if used or loading, full alpha otherwise
if (used)
{
    image_alpha = 0.2;
}
else if (!oBoard.board_data_loaded)
{
    image_alpha = 0.4; // Dim while loading
}
else
{
    image_alpha = 1.0;
}

draw_self();
