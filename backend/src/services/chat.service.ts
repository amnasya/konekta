import { pool, DbRow, DbResult } from '../config/db';
import { ApiError } from '../utils/apiError';

function pair(a: number, b: number): [number, number] {
  return a < b ? [a, b] : [b, a];
}

export const chatService = {
  async listConversations(userId: number) {
    const [rows] = await pool.query<DbRow[]>(
      `SELECT c.*, ua.name AS user_a_name, ub.name AS user_b_name,
              bp.brand_name, ip.username AS influencer_username,
              m.message_text AS last_message,
              (SELECT COUNT(*) FROM messages msg
                 WHERE msg.conversation_id = c.id
                   AND msg.sender_user_id != ?
                   AND msg.id > COALESCE((SELECT last_read_message_id FROM conversation_reads
                                            WHERE conversation_id = c.id AND user_id = ?), 0)
              ) AS unread_count
       FROM conversations c
       JOIN users ua ON ua.id = c.user_a_id
       JOIN users ub ON ub.id = c.user_b_id
       LEFT JOIN brand_profiles bp ON bp.user_id = CASE WHEN c.user_a_id = ? THEN c.user_a_id ELSE c.user_b_id END
       LEFT JOIN influencer_profiles ip ON ip.user_id = CASE WHEN c.user_a_id = ? THEN c.user_a_id ELSE c.user_b_id END
       LEFT JOIN messages m ON m.id = (
            SELECT id FROM messages WHERE conversation_id = c.id ORDER BY created_at DESC LIMIT 1
       )
       WHERE c.user_a_id = ? OR c.user_b_id = ?
       ORDER BY c.last_message_at DESC`,
      [userId, userId, userId, userId, userId, userId]
    );
    return rows;
  },

  async startConversation(userA: number, userB: number, offerId?: number) {
    if (userA === userB) throw new ApiError(400, 'Cannot start a conversation with yourself');
    const [a, b] = pair(userA, userB);

    // try find existing
    const [existing] = await pool.query<DbRow[]>(
      'SELECT id FROM conversations WHERE user_a_id = ? AND user_b_id = ? AND IFNULL(offer_id,0) = IFNULL(?,0) LIMIT 1',
      [a, b, offerId ?? null]
    );
    if (existing.length) return existing[0];

    const [r] = await pool.query<DbResult>(
      'INSERT INTO conversations (user_a_id, user_b_id, offer_id) VALUES (?,?,?)',
      [a, b, offerId ?? null]
    );
    return { id: (r as DbResult).insertId };
  },

  async getMessages(conversationId: number, userId: number) {
    const [conv] = await pool.query<DbRow[]>(
      'SELECT * FROM conversations WHERE id = ?',
      [conversationId]
    );
    if (!conv.length) throw new ApiError(404, 'Conversation not found');
    const c = conv[0] as { user_a_id: number; user_b_id: number };
    if (c.user_a_id !== userId && c.user_b_id !== userId) {
      throw new ApiError(403, 'Not part of this conversation');
    }

    const [msgs] = await pool.query<DbRow[]>(
      'SELECT * FROM messages WHERE conversation_id = ? ORDER BY created_at ASC',
      [conversationId]
    );
    return msgs;
  },

  async sendMessage(conversationId: number, senderId: number, text: string, attachment?: string) {
    const [conv] = await pool.query<DbRow[]>(
      'SELECT * FROM conversations WHERE id = ?',
      [conversationId]
    );
    if (!conv.length) throw new ApiError(404, 'Conversation not found');
    const c = conv[0] as { user_a_id: number; user_b_id: number };
    if (c.user_a_id !== senderId && c.user_b_id !== senderId) {
      throw new ApiError(403, 'Not part of this conversation');
    }

    const [r] = await pool.query<DbResult>(
      'INSERT INTO messages (conversation_id, sender_user_id, message_text, attachment_url) VALUES (?,?,?,?)',
      [conversationId, senderId, text, attachment ?? null]
    );
    await pool.query('UPDATE conversations SET last_message_at = NOW() WHERE id = ?', [conversationId]);

    const recipient = c.user_a_id === senderId ? c.user_b_id : c.user_a_id;
    await pool.query(
      `INSERT INTO notifications (user_id, type, title, body, icon)
       VALUES (?, 'message', 'New message', ?, 'chat')`,
      [recipient, text.slice(0, 80)]
    );

    return { id: (r as DbResult).insertId, conversation_id: conversationId, sender_user_id: senderId, message_text: text, attachment_url: attachment ?? null };
  },
};
