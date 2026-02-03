import type { Request, Response } from 'express';
import { Router } from "express";
import { context, reddit, redis } from "@devvit/web/server";

const router = Router();

/**
 * GET /api/submit-score
 * Submit user score to leaderboard
 */
router.post("/api/submit-score", async (req: Request, res:Response): Promise<void> => {
    
    try {
        const { postId, postData } = context;
        const { totalMoves, cellsTravelled } = req.body;
        const currentUser = await reddit.getCurrentUser();
    
        if (!postId) {
            console.error("API Board Data Error: postId not found in devvit context");
            res.status(400).json({
                status: "error",
                message: "postId is required but missing from context",
            });
            return;
        }

        if (!currentUser) {
            console.error("API Board Data Error: User not found in devvit context");
            res.status(400).json({
                status: "error",
                message: "User is required but missing from context",
            });
            return;
        }

        const userId = currentUser.id;
        const avatar = await currentUser.getSnoovatarUrl() || null;




        // Return the board data from postData
        res.json({
            status: "success",
            totalMoves,
            cellsTravelled,
            currentUser,
            avatar
        });
    } catch (error) {

        let errorMessage = "Unknown error fetching board data";
        if (error instanceof Error) {
            errorMessage = `Failed to fetch board data: ${error.message}`;
        }
        res.status(400).json({ status: "error", message: errorMessage });
    }
});

export default router;
