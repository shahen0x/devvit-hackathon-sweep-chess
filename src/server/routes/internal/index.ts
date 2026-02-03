import { Router } from "express";
import onAppInstallRoute from "./on-app-install";
import postCreateRoute from "./post-create";

const router = Router();

// Mount internal routes
router.use(onAppInstallRoute);
router.use(postCreateRoute);

export default router;
