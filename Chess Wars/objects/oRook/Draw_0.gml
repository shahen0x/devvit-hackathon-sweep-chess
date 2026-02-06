// Draw the rook sprite if assigned, otherwise draw a placeholder
if (sprite_index != -1)
{
    // Animate spawn scale
    if (spawn_animating)
    {
        spawn_scale += spawn_speed;
        if (spawn_scale >= 1)
        {
            spawn_scale = 1;
            spawn_animating = false;
        }
    }
    
    // Draw 144x144 sprite stretched to fit global.cell_size with spawn animation
    draw_set_color(c_white);
    draw_set_alpha(1);
    
    // Calculate scaled size for spawn animation
    var scaled_size = global.cell_size * spawn_scale * 0.9;
    var offset = (global.cell_size - scaled_size) / 2;
    
    draw_sprite_stretched(sprite_index, image_index, px + offset, py + offset, scaled_size, scaled_size);
}
else
{
    // Draw placeholder rectangle for rook
    draw_set_color(c_blue);
    draw_rectangle(px, py, px + global.cell_size, py + global.cell_size, false);
    draw_set_color(c_white);
}
