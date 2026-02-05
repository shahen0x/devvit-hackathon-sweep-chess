// Left Click event - Toggle mute

// Toggle mute state
is_muted = !is_muted;

if (is_muted) {
    // Mute all audio
    audio_master_gain(0);
    sprite_index = sVolumeOff;
} else {
    // Unmute - restore to full volume
    audio_master_gain(1);
    sprite_index = sVolumeOn;
}

// Save the setting to localStorage
settings_save("is_muted", is_muted);
