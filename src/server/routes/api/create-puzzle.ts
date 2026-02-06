import { Router } from 'express';
import { context, reddit, redis } from '@devvit/web/server';
import type { CreatePuzzleRequest, CreatePuzzleResponse } from '../../../shared/types/api';

const router = Router();

// Validate board data
function validateBoard(board: number[][]): { valid: boolean; error?: string } {
	// Check if board is 8x8
	if (!Array.isArray(board) || board.length !== 8) {
		return { valid: false, error: 'Board must be 8x8' };
	}

	for (const row of board) {
		if (!Array.isArray(row) || row.length !== 8) {
			return { valid: false, error: 'Board must be 8x8' };
		}

		for (const cell of row) {
			if (cell !== 0 && cell !== 1) {
				return { valid: false, error: 'Board cells must be 0 or 1' };
			}
		}
	}

	// Count pawns
	const pawnCount = board.flat().filter((cell) => cell === 1).length;
	if (pawnCount !== 24) {
		return { valid: false, error: `Board must have exactly 24 pawns, found ${pawnCount}` };
	}

	return { valid: true };
}

router.post('/api/create-puzzle', async (req, res) => {
	try {
		const { board } = req.body as CreatePuzzleRequest;
		const { subredditName, userId } = context;

		if (!subredditName) {
			return res.status(400).json({ error: 'Subreddit name is required' });
		}

		if (!userId) {
			return res.status(401).json({ error: 'User must be logged in' });
		}

		// Validate board
		const validation = validateBoard(board);
		if (!validation.valid) {
			return res.status(400).json({ error: validation.error });
		}

		// Get current user info
		const user = await reddit.getCurrentUser();
		const username = user?.username || 'Anonymous';

		// Get and increment the puzzle counter
		const puzzleNumber = await redis.incrBy('puzzle:counter', 1);

		// Create the post
		const post = await reddit.submitCustomPost({
			subredditName: subredditName,
			title: `Sweep Chess - Community Puzzle #${puzzleNumber} by u/${username}`,
			entry: 'default',
			postData: {
				gameId: `community-${puzzleNumber}`,
				board: board,
				createdBy: username,
				createdAt: new Date().toISOString(),
			},
		});

		// Construct the proper Reddit post URL
		const cleanPostId = post.id.replace(/^t3_/, '');
		const postUrl = `https://reddit.com/comments/${cleanPostId}`;

		const response: CreatePuzzleResponse = {
			success: true,
			postId: post.id,
			postUrl: postUrl,
			message: 'Puzzle created successfully!',
		};

		res.json(response);
	} catch (error) {
		console.error('Error creating puzzle:', error);
		res.status(500).json({
			error: 'Failed to create puzzle',
			message: error instanceof Error ? error.message : 'Unknown error',
		});
	}
});

export default router;
