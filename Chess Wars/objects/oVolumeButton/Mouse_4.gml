// Left Click event - Toggle mute

// Toggle mute state
is_muted = !is_muted;

if (is_muted) {
    // Mute all audio
    audio_master_gain(0);
    sprite_index = global.is_mobile ? sVolumeOff : sVolumeOffDesktop;
} else {
    // Unmute - restore to full volume
    audio_master_gain(1);
    sprite_index = global.is_mobile ?  sVolumeOn : sVolumeOnDesktop;
}

// Save the setting to localStorage
settings_save("is_muted", is_muted);
