import { Router } from "express";
import initRoute from "./init";
import boardDataRoute from "./board-data";
import submitScore from "./submit-score";

const router = Router();

// Mount API routes
router.use(initRoute);
router.use(boardDataRoute);
router.use(submitScore)

export default router;
