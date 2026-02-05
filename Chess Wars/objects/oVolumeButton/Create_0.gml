// Initialize volume button state
// Load saved mute setting from localStorage (default: false/unmuted)
is_muted = settings_load("is_muted", false);

// Apply the loaded setting
if (is_muted) {
    audio_master_gain(0);
    sprite_index = sVolumeOff;
} else {
    audio_master_gain(1);
    sprite_index = sVolumeOn;
}
