import { Request, Response, NextFunction } from 'express';
import { z } from 'zod';
import { chatService } from '../services/chat.service';
import { ok, created } from '../utils/response';
import { ApiError } from '../utils/apiError';

const startSchema = z.object({
  other_user_id: z.number().int().positive(),
  offer_id: z.number().int().positive().optional(),
});

const messageSchema = z.object({
  message_text: z.string().min(1).max(2000),
  attachment_url: z.string().max(500).optional(),
});

export const chatController = {
  async list(req: Request, res: Response, next: NextFunction) {
    try {
      if (!req.user) throw new ApiError(401, 'Unauthenticated');
      const data = await chatService.listConversations(req.user.id);
      return ok(res, { items: data });
    } catch (e) { next(e); }
  },
  async start(req: Request, res: Response, next: NextFunction) {
    try {
      if (!req.user) throw new ApiError(401, 'Unauthenticated');
      const body = startSchema.parse(req.body);
      const conv = await chatService.startConversation(req.user.id, body.other_user_id, body.offer_id);
      return ok(res, conv);
    } catch (e) { next(e); }
  },
  async messages(req: Request, res: Response, next: NextFunction) {
    try {
      if (!req.user) throw new ApiError(401, 'Unauthenticated');
      const id = Number(req.params.id);
      if (!Number.isFinite(id)) throw new ApiError(400, 'Invalid id');
      const data = await chatService.getMessages(id, req.user.id);
      return ok(res, { items: data });
    } catch (e) { next(e); }
  },
  async send(req: Request, res: Response, next: NextFunction) {
    try {
      if (!req.user) throw new ApiError(401, 'Unauthenticated');
      const id = Number(req.params.id);
      if (!Number.isFinite(id)) throw new ApiError(400, 'Invalid id');
      const body = messageSchema.parse(req.body);
      const data = await chatService.sendMessage(id, req.user.id, body.message_text, body.attachment_url);
      return created(res, data, 'Message sent');
    } catch (e) { next(e); }
  },
};
