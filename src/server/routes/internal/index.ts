import { Router } from 'express';
import onAppInstallRoute from './on-app-install';
import postCreateRoute from './post-create';
import creatorCreateRoute from './creator-create';

const router = Router();

// Mount internal routes
router.use(onAppInstallRoute);
router.use(postCreateRoute);
router.use(creatorCreateRoute);

export default router;
