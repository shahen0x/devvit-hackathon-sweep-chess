/// @func clear_board_cache()
/// @desc Clears the cached board data, forcing a fresh fetch on next game start
function clear_board_cache() {
	global.cached_board_data = undefined;
	global.board_cache_valid = false;
	global.board_cache_timestamp = undefined;
	show_debug_message("Board cache cleared - next game will fetch fresh data");
}

/// @func is_board_cache_valid()
/// @desc Returns true if cached board data is available and valid (not expired)
function is_board_cache_valid() {
	if (!variable_global_exists("board_cache_valid") || 
	    !global.board_cache_valid || 
	    is_undefined(global.cached_board_data)) {
		return false;
	}
	
	// Check if cache has expired (30 minutes = 1800000 milliseconds)
	var cache_expiry_time = 1800000; // 30 minutes
	if (variable_global_exists("board_cache_timestamp") && 
	    !is_undefined(global.board_cache_timestamp)) {
		var time_elapsed = current_time - global.board_cache_timestamp;
		if (time_elapsed > cache_expiry_time) {
			show_debug_message("Board cache expired after " + string(time_elapsed / 60000) + " minutes");
			clear_board_cache();
			return false;
		}
	}
	
	return true;
}

/// @func get_cached_board_data()
/// @desc Returns the cached board data if available, undefined otherwise
function get_cached_board_data() {
	if (is_board_cache_valid()) {
		return global.cached_board_data;
	}
	return undefined;
}

/// @func cache_board_data(data)
/// @desc Stores board data in the cache for future use
/// @param {Struct} data The board data to cache
function cache_board_data(_data) {
	global.cached_board_data = _data;
	global.board_cache_valid = true;
	global.board_cache_timestamp = current_time;
	show_debug_message("Board data cached for future restarts (expires in 30 minutes)");
}

/// @func get_cache_age_minutes()
/// @desc Returns the age of the cached data in minutes, or -1 if no cache
function get_cache_age_minutes() {
	if (!is_board_cache_valid() || 
	    !variable_global_exists("board_cache_timestamp") || 
	    is_undefined(global.board_cache_timestamp)) {
		return -1;
	}
	
	var time_elapsed = current_time - global.board_cache_timestamp;
	return time_elapsed / 60000; // Convert milliseconds to minutes
}