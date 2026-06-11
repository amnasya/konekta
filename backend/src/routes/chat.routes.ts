import { Router } from 'express';
import { chatController } from '../controllers/chat.controller';
import { requireAuth } from '../middlewares/auth';

const r = Router();
r.use(requireAuth);
r.get('/', chatController.list);
r.post('/', chatController.start);
r.get('/:id/messages', chatController.messages);
r.post('/:id/messages', chatController.send);
export default r;
