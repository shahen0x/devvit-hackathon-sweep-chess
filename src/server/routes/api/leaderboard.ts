import type { Request, Response } from 'express';
import { Router } from 'express';
import { context, redis } from '@devvit/web/server';

const router = Router();

/**
 * GET /api/leaderboard
 * Get top scores from leaderboard
 */
router.get('/api/leaderboard', async (req: Request, res: Response): Promise<void> => {
	try {
		const { postId } = context;

		if (!postId) {
			res.status(400).json({
				status: 'error',
				message: 'Unable to find postId',
			});
			return;
		}

		const limit = 50;
		const leaderboardKey = `leaderboard:${postId}`;
		console.log('[LEADERBOARD] Fetching from key:', leaderboardKey);

		// Fetch top 50 users with scores
		// Note: Devvit Redis zRange returns in ascending order (lowest scores first)
		// Since we want highest scores first, we'll need to reverse the array
		const entries = await redis.zRange(leaderboardKey, 0, limit - 1);
		console.log('[LEADERBOARD] Raw entries:', JSON.stringify(entries, null, 2));

		// If no entries, return empty array
		if (!entries || entries.length === 0) {
			console.log('[LEADERBOARD] No entries found');
			res.json([]);
			return;
		}

		// Reverse to get highest scores first
		const sortedEntries = [...entries].reverse();

		// Fetch user metadata and stats in parallel
		const leaderboard = await Promise.all(
			sortedEntries.map(async (entry, index) => {
				const userId = entry.member;
				const userKey = `user:${userId}`;
				const statsKey = `user:${userId}:stats:${postId}`;

				const [userMeta, userStats] = await Promise.all([
					redis.hGetAll(userKey),
					redis.hGetAll(statsKey),
				]);

				return {
					rank: index + 1,
					userId,
					username: userMeta.username ?? null,
					snoovatar: userMeta.avatar ?? null,
					totalMoves: userStats.totalMoves ? Number(userStats.totalMoves) : null,
					cellsTravelled: userStats.cellsTravelled
						? Number(userStats.cellsTravelled)
						: null,
					score: entry.score,
				};
			})
		);

		console.log('[LEADERBOARD] Returning leaderboard with', leaderboard.length, 'entries');
		res.json(leaderboard);
	} catch (error) {
		console.error('Leaderboard Error:', error);
		let errorMessage = 'Unknown error fetching leaderboard';
		if (error instanceof Error) {
			errorMessage = `Failed to fetch leaderboard: ${error.message}`;
		}
		res.status(500).json({ status: 'error', message: errorMessage });
	}
});

export default router;
