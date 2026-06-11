import { Request, Response, NextFunction } from 'express';
import { notificationService } from '../services/notification.service';
import { ok } from '../utils/response';
import { ApiError } from '../utils/apiError';

export const notificationController = {
  async list(req: Request, res: Response, next: NextFunction) {
    try {
      if (!req.user) throw new ApiError(401, 'Unauthenticated');
      const data = await notificationService.list(req.user.id);
      return ok(res, data);
    } catch (e) { next(e); }
  },
  async markRead(req: Request, res: Response, next: NextFunction) {
    try {
      if (!req.user) throw new ApiError(401, 'Unauthenticated');
      const id = Number(req.params.id);
      if (!Number.isFinite(id)) throw new ApiError(400, 'Invalid id');
      const data = await notificationService.markRead(req.user.id, id);
      return ok(res, data, 'Marked as read');
    } catch (e) { next(e); }
  },
  async markAll(req: Request, res: Response, next: NextFunction) {
    try {
      if (!req.user) throw new ApiError(401, 'Unauthenticated');
      const data = await notificationService.markAllRead(req.user.id);
      return ok(res, data, 'All marked as read');
    } catch (e) { next(e); }
  },
};
