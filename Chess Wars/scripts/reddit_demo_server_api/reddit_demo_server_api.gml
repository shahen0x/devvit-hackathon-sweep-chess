/// @ignore
function api_get_http_manager() {
	with (obj_http_manager) return self;
	return instance_create_depth(0, 0, 0, obj_http_manager);
}

/// @ignore
function api_register_request(_req, _callback) {
	var _manager = api_get_http_manager();
	_manager.register(_req, _callback);
}

/// @desc This function retrieves the board data from the server to create the level.
/// For more details check the server implementation under the output folder:
/// <output>/<project_name>/src/server/index.ts
/// @param {Function} _callback The callback that you want to be executed upon task completion.
function api_get_board_data(_callback) {
	
	// Build request url
	var _url = reddit_get_base_url() + "/api/board-data";
	
	// Build request headers
	var _headers = ds_map_create();
	ds_map_add(_headers, "Authorization", $"Bearer {reddit_get_token()}");
	
	// Make request
	var _req = http_request(_url, "GET", _headers, "");
	
	// Free memory
	ds_map_destroy(_headers);
	
	// Register request callback
	if (is_callable(_callback)) api_register_request(_req, _callback);
	
	return _req;
}

/// @desc This function submits the player's score to the server.
/// @param {Real} _totalMoves The total number of moves made by the player
/// @param {Real} _cellsTravelled The total number of cells travelled by the player
/// @param {Function} _callback The callback that you want to be executed upon task completion.
function api_submit_score(_totalMoves, _cellsTravelled, _callback) {
	
	// Build request url
	var _url = reddit_get_base_url() + "/api/submit-score";
	
	// Build request headers
	var _headers = ds_map_create();
	ds_map_add(_headers, "Authorization", $"Bearer {reddit_get_token()}");
	ds_map_add(_headers, "Content-Type", "application/json");
	
	// Build request body
	var _body = json_stringify({
		totalMoves: _totalMoves,
		cellsTravelled: _cellsTravelled
	});
	
	// Make request
	var _req = http_request(_url, "POST", _headers, _body);
	
	// Free memory
	ds_map_destroy(_headers);
	
	// Register request callback
	if (is_callable(_callback)) api_register_request(_req, _callback);
	
	return _req;
}
