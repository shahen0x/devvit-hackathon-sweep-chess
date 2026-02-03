import { Router } from "express";
import { context } from "@devvit/web/server";
import { createPost } from "../../core/post";

const router = Router();

/**
 * POST /internal/on-app-install
 * Called when the app is installed - creates an initial post
 */
router.post("/internal/on-app-install", async (_req, res): Promise<void> => {
	try {
		const post = await createPost();

		res.json({
			status: "success",
			message: `Post created in subreddit ${context.subredditName} with id ${post.id}`,
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
