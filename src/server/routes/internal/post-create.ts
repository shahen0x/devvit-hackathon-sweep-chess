import { Router } from "express";
import { context } from "@devvit/web/server";
import { createPost } from "../../core/post";

const router = Router();

/**
 * POST /internal/menu/post-create
 * Called from the subreddit menu to create a new post
 */
router.post("/internal/menu/post-create", async (_req, res): Promise<void> => {
	try {
		const post = await createPost();

		res.json({
			navigateTo: `https://reddit.com/r/${context.subredditName}/comments/${post.id}`,
		});
	} catch (error) {
		console.error(`Error creating post: ${error}`);
		res.status(400).json({
			status: "error",
			message: "Failed to create post",
		});
	}
});

export default router;
