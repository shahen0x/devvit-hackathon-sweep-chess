import { Router } from 'express';
import initRoute from './init';
import boardDataRoute from './board-data';
import submitScore from './submit-score';
import leaderboard from './leaderboard';
import deleteScore from './delete-score';
import trackPlayer from './track-player';
import playerCount from './player-count';
import topPlayer from './top-player';

const router = Router();

// Mount API routes
router.use(initRoute);
router.use(boardDataRoute);
router.use(submitScore);
router.use(leaderboard);
router.use(deleteScore);
router.use(trackPlayer);
router.use(playerCount);
router.use(topPlayer);

export default router;
