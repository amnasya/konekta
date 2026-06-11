import { Router } from 'express';
import { offerController } from '../controllers/offer.controller';
import { requireAuth } from '../middlewares/auth';

const r = Router();
r.use(requireAuth);
r.post('/', offerController.create);
r.get('/', offerController.list);
r.get('/:id', offerController.detail);
r.patch('/:id/status', offerController.updateStatus);
export default r;
