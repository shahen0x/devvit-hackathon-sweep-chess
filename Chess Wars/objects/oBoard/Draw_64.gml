// Draw GUI event - always draws on top of everything

// Draw game over overlay
if (game_over)
{
    // Semi-transparent black overlay
    draw_set_alpha(0.7);
    draw_set_color(c_black);
    draw_rectangle(0, 0, room_width, room_height, false);
    draw_set_alpha(1.0);
    
    // Game Over text
    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    
    var center_x = room_width / 2;
    var center_y = room_height / 2;
    
    draw_text(center_x, center_y - 80, "GAME OVER");
    draw_text(center_x, center_y - 40, "All Pawns Eliminated!");
    draw_text(center_x, center_y, "Final Moves: " + string(total_moves));
    draw_text(center_x, center_y + 20, "Cells Travelled: " + string(cells_travelled));
    
    // Restart button
    var mx = mouse_x;
    var my = mouse_y;
    var hovering = point_in_rectangle(mx, my, restart_button_x, restart_button_y,
                                      restart_button_x + restart_button_w, restart_button_y + restart_button_h);
    
    // Button background
    draw_set_color(hovering ? c_black : c_dkgray);
    draw_rectangle(restart_button_x, restart_button_y, 
                  restart_button_x + restart_button_w, restart_button_y + restart_button_h, false);
    
    // Button border
    draw_set_color(c_white);
    draw_rectangle(restart_button_x, restart_button_y, 
                  restart_button_x + restart_button_w, restart_button_y + restart_button_h, true);
    
    // Button text
    draw_text(center_x, restart_button_y + restart_button_h / 2, "RESTART");
    
    // Reset alignment
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}
