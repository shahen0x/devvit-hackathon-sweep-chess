# Sweep Chess

A daily optimization puzzle game that reimagines chess as a strategic clearing challenge. Built with GameMaker and Reddit's Devvit platform.

## What is Sweep Chess?

Sweep Chess strips chess down to its movement mechanics and transforms it into an optimization puzzle. Instead of battling an opponent, you're clearing a board of 24 enemy pawns using just four pieces: a queen, rook, bishop, and knight. The goal is simple: clear the board in as few moves as possible.

The twist? Pawns don't block movement. When a piece moves, it sweeps through and captures every pawn in its path, turning each move into a potential multi-capture. This creates a puzzle where finding the optimal solution requires careful planning and spatial reasoning.

## Features

### Daily Challenges

-   **Deterministic Puzzles**: Every player gets the same board each day, generated from the post date as a seed
-   **Competitions**: Compete on a leaderboard ranked by fewest moves and shortest distance traveled
-   **Unlimited Attempts**: Replay the daily puzzle as many times as you want to find the optimal solution
-   **Automatic Posts**: New challenges are automatically posted daily via scheduled tasks

### Custom Level Creator

-   **Build Your Own Puzzles**: Place up to 24 pawns anywhere on the board
-   **Instant Publishing**: Custom levels are automatically posted to Reddit as playable challenges
-   **Community Content**: Share your creations and challenge other players

### Game Mechanics

-   **Chess Movement Rules**: Each piece moves according to traditional chess rules
-   **Sweep Captures**: Pieces capture all pawns along their movement path
-   **Strategic Placement**: Any white piece can be placed on an empty cell to start
-   **Knight Exception**: The knight can be placed directly on a pawn, capturing it immediately
-   **Move Optimization**: Scores are based on total moves and cells traveled

### Platform Integration

-   **Native Reddit Experience**: Runs directly in Reddit posts using Devvit WebViews
-   **Mobile-First Design**: Optimized for all screen sizes and devices
-   **User Identity**: Automatic player tracking and personalized leaderboards
-   **Persistent Scores**: Redis-backed storage keeps only your best daily result

## How To Play

### Objective

Clear the board by capturing all pieces using fewer moves and less distance(cells).

### How to Play

-   Any white piece can be placed on an empty cell.
-   The Knight can be placed on a pawn, capturing it.
-   Valid moves are highlighted.
-   Pawns do not block movement. Pieces pass through and wipe them.

## License

BSD-3-Clause
