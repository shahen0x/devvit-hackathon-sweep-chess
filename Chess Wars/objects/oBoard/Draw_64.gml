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
    
    // Display score submission status
    if (!score_submitted) {
        draw_set_color(c_yellow);
        draw_text(center_x, center_y + 40, "Submitting score...");
        draw_set_color(c_white);
    } else if (score_submission_status == "success") {
        draw_set_color(c_lime);
        draw_text(center_x, center_y + 40, "Score submitted successfully!");
        draw_set_color(c_white);
    } else if (score_submission_status == "failed") {
        draw_set_color(c_red);
        draw_text(center_x, center_y + 40, "Failed to submit score");
        draw_set_color(c_white);
    }
    
    // Restart button
    var mx = mouse_x;
    var my = mouse_y;
    var hovering = restart_button_enabled && point_in_rectangle(mx, my, restart_button_x, restart_button_y,
                                      restart_button_x + restart_button_w, restart_button_y + restart_button_h);
    
    // Button background - greyed out if not enabled
    if (!restart_button_enabled) {
        draw_set_color(c_gray);
    } else {
        draw_set_color(hovering ? c_black : c_dkgray);
    }
    draw_rectangle(restart_button_x, restart_button_y, 
                  restart_button_x + restart_button_w, restart_button_y + restart_button_h, false);
    
    // Button border
    draw_set_color(restart_button_enabled ? c_white : c_dkgray);
    draw_rectangle(restart_button_x, restart_button_y, 
                  restart_button_x + restart_button_w, restart_button_y + restart_button_h, true);
    
    // Button text
    draw_set_color(restart_button_enabled ? c_white : c_dkgray);
    draw_text(center_x, restart_button_y + restart_button_h / 2, "RESTART");
    
    // Reset alignment
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

// Draw debug logs on screen (for mobile debugging)
//draw_set_color(c_yellow);
//draw_set_halign(fa_left);
//draw_set_valign(fa_top);
//draw_set_alpha(0.9);

//var log_y = 60;
//for (var i = 0; i < array_length(global.debug_logs); i++) {
//	draw_text(8, log_y, global.debug_logs[i]);
//	log_y += 16;
//}

//draw_set_alpha(1.0);
//draw_set_color(c_white);

// Draw cache status and controls (only for Reddit builds)
//if (is_reddit_build() && !game_over) {
//    draw_set_halign(fa_left);
//    draw_set_valign(fa_top);
//    draw_set_alpha(0.8);
    
//    var status_text = "";
//    var cache_age = get_cache_age_minutes();
    
//    if (is_board_cache_valid() && cache_age >= 0) {
//        draw_set_color(c_lime);
//        var age_text = "";
//        if (cache_age < 1) {
//            age_text = "< 1 min";
//        } else {
//            age_text = string(floor(cache_age)) + " min";
//        }
//        status_text = "Board: Cached (" + age_text + " old)";
//    } else {
//        draw_set_color(c_yellow);
//        status_text = "Board: Fresh";
//    }
    
//    draw_text(8, 8, status_text);
    
//    // Show F5 instruction
//    draw_set_color(c_white);
//    draw_text(8, 28, "Press F5 for fresh data");
    
//    draw_set_alpha(1.0);
//    draw_set_halign(fa_left);
//    draw_set_valign(fa_top);
//}

// Draw debug info on top right corner
draw_set_halign(fa_right);
draw_set_valign(fa_top);
draw_set_color(c_yellow);
draw_set_alpha(0.9);

var debug_x = room_width - 8;
var debug_y = 8;
var line_height = 20;

draw_text(debug_x, debug_y, "browser_width: " + string(browser_width));
debug_y += line_height;
draw_text(debug_x, debug_y, "browser_height: " + string(browser_height));
debug_y += line_height;
draw_text(debug_x, debug_y, "display_get_width(): " + string(display_get_width()));
debug_y += line_height;
draw_text(debug_x, debug_y, "display_get_height(): " + string(display_get_height()));
debug_y += line_height;
draw_text(debug_x, debug_y, "os_type: " + string(os_type));
debug_y += line_height;
draw_text(debug_x, debug_y, "os_browser: " + string(os_browser));
debug_y += line_height;

// Check if running in browser using alternative method
var is_web = (os_type == os_browser);
draw_text(debug_x, debug_y, "is_web: " + string(is_web));
debug_y += line_height;

// User agent check (HTML5 only)
if (os_type == os_browser) {
    var ua = os_get_info()[? "browser_user_agent"];
    if (!is_undefined(ua)) {
        draw_text(debug_x, debug_y, "User Agent: " + string_copy(ua, 1, 30) + "...");
    }
}

// Reset draw settings
draw_set_alpha(1.0);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
