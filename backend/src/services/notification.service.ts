import { pool, DbRow } from '../config/db';

export const notificationService = {
  async list(userId: number) {
    const [rows] = await pool.query<DbRow[]>(
      `SELECT * FROM notifications WHERE user_id = ? ORDER BY created_at DESC LIMIT 100`,
      [userId]
    );
    const [[{ unread }]] = await pool.query<DbRow[]>(
      'SELECT COUNT(*) AS unread FROM notifications WHERE user_id = ? AND read_status = 0',
      [userId]
    );
    return { items: rows, unread: (unread as number) ?? 0 };
  },
  async markRead(userId: number, id: number) {
    await pool.query(
      'UPDATE notifications SET read_status = 1 WHERE id = ? AND user_id = ?',
      [id, userId]
    );
    return { id, read_status: 1 };
  },
  async markAllRead(userId: number) {
    await pool.query('UPDATE notifications SET read_status = 1 WHERE user_id = ?', [userId]);
    return { updated: true };
  },
};
