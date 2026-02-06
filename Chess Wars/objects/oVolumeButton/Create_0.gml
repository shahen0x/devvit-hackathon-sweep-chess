// Initialize volume button state
// Load saved mute setting from localStorage (default: false/unmuted)
is_muted = settings_load("is_muted", false);

// Apply the loaded setting
if (is_muted) {
    audio_master_gain(0);
    sprite_index = global.is_mobile ? sVolumeOff : sVolumeOffDesktop;
} else {
    audio_master_gain(1);
    sprite_index = global.is_mobile ?  sVolumeOn : sVolumeOnDesktop;
}

if (!global.is_mobile) {
	x = room_width - 70
	y = 10
	image_xscale = 0.4	
	image_yscale = 0.4
}
