import { Router } from "express";
import initRoute from "./init";
import boardDataRoute from "./board-data";

const router = Router();

// Mount API routes
router.use(initRoute);
router.use(boardDataRoute);

export default router;
