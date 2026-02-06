import { Router } from 'express';
import onAppInstallRoute from './on-app-install';
import postCreateRoute from './post-create';
import creatorCreateRoute from './creator-create';
import schedulerPostDailyChallengeRoute from './scheduler-post-daily-challenge';
import schedulerRetryDailyChallengeRoute from './scheduler-retry-daily-challenge';

const router = Router();

// Mount internal routes
router.use(onAppInstallRoute);
router.use(postCreateRoute);
router.use(creatorCreateRoute);
router.use(schedulerPostDailyChallengeRoute);
router.use(schedulerRetryDailyChallengeRoute);

export default router;
