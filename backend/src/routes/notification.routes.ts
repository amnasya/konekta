import { Router } from 'express';
import { notificationController } from '../controllers/notification.controller';
import { requireAuth } from '../middlewares/auth';

const r = Router();
r.use(requireAuth);
r.get('/', notificationController.list);
r.patch('/read-all', notificationController.markAll);
r.patch('/:id/read', notificationController.markRead);
export default r;
