import { Router } from 'express';
import { context } from '@devvit/web/server';
import { createCreatorPost } from '../../core/post';

const router = Router();

/**
 * POST /internal/menu/creator-create
 * Called from the subreddit menu to create a new level creator post
 */
router.post('/internal/menu/creator-create', async (_req, res): Promise<void> => {
	try {
		const post = await createCreatorPost();

		res.json({
			navigateTo: `https://reddit.com/r/${context.subredditName}/comments/${post.id}`,
		});
	} catch (error) {
		console.error(`Error creating creator post: ${error}`);
		res.status(400).json({
			status: 'error',
			message: 'Failed to create creator post',
		});
	}
});

export default router;
