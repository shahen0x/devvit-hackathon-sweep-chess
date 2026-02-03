# How to Receive Board Data in GameMaker

The board data is sent from the React app to GameMaker using the async event system.

## In GameMaker - Receiving Board Data

### Step 1: Add Async - Social Event

In your controller object (e.g., `oBoard`), add an **Async - Social** event with this code:

```gml
// Async - Social Event
var event_type = async_load[? "type"];

if (event_type == "board_data_received") {
    var board_json = async_load[? "data"];

    show_debug_message("Board data received!");
    show_debug_message(board_json);

    // Parse the JSON to get the 2D array
    var board_data = json_parse(board_json);

    // board_data is now an array containing your 8x8 board
    // Process it here...

    // Example: Loop through the board
    for (var x = 0; x < array_length(board_data); x++) {
        var column = board_data[x];
        for (var y = 0; y < array_length(column); y++) {
            if (column[y] == 1) {
                show_debug_message("Pawn at position: " + string(x) + "," + string(y));

                // Spawn your pawn here
                // instance_create_layer(x * CELL_SIZE, y * CELL_SIZE, "Pieces", oPawn);
            }
        }
    }
}
```

### Step 2: That's it!

The board data will be automatically sent when:

1. GameMaker registers its async method (happens during game initialization)
2. The data is sent 100ms after registration to ensure GameMaker is ready

## Board Data Structure

The board data is a 2D array (8x8) where:

- `board[x][y]` where x is column (0-7), y is row (0-7)
- `0` = empty cell
- `1` = pawn

Example:

```json
[
  [0, 0, 0, 0, 1, 0, 0, 0],
  [0, 1, 0, 0, 0, 1, 0, 1],
  [0, 0, 0, 0, 1, 0, 0, 0],
  [0, 0, 0, 0, 1, 1, 1, 0],
  [0, 1, 1, 1, 1, 0, 0, 0],
  [0, 0, 0, 0, 1, 0, 0, 0],
  [0, 0, 0, 0, 1, 0, 0, 0],
  [0, 0, 0, 1, 1, 0, 0, 0]
]
```

## Testing

To verify the data is being sent, check the browser console (F12). You should see:

- "setAddAsyncMethod called with: [function]"
- "Sending board data to GameMaker: [array]"
- "Board data sent to GameMaker successfully"

## Manual Testing

You can manually trigger the send from browser console:

```javascript
window.sendBoardDataToGM([[0,1,0,0,0,0,0,0], [0,0,1,0,0,0,0,0], ...])
```
