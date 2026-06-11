import { Request, Response, NextFunction } from 'express';
import { dashboardService } from '../services/dashboard.service';
import { ok } from '../utils/response';
import { ApiError } from '../utils/apiError';

export const dashboardController = {
  async overview(req: Request, res: Response, next: NextFunction) {
    try {
      if (!req.user) throw new ApiError(401, 'Unauthenticated');
      const data = req.user.role === 'brand'
        ? await dashboardService.brandOverview(req.user.id)
        : await dashboardService.influencerOverview(req.user.id);
      return ok(res, data);
    } catch (e) { next(e); }
  },
};
