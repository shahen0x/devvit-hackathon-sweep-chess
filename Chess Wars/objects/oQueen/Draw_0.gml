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

// Draw 144x144 sprite stretched to fit CELL_SIZE with spawn animation
draw_set_color(c_white);
draw_set_alpha(1);

// Calculate scaled size for spawn animation
var scaled_size = CELL_SIZE * spawn_scale * 0.9;
var offset = (CELL_SIZE - scaled_size) / 2;

draw_sprite_stretched(sprite_index, image_index, px + offset, py + offset, scaled_size, scaled_size);
