import { pool, DbRow } from '../config/db';

export const dashboardService = {
  async influencerOverview(userId: number) {
    const [[profile]] = await pool.query<DbRow[]>(
      'SELECT followers_count, engagement_rate FROM influencer_profiles WHERE user_id = ?',
      [userId]
    );
    const [[earnings]] = await pool.query<DbRow[]>(
      'SELECT COALESCE(SUM(amount),0) AS total FROM earnings WHERE influencer_user_id = ?',
      [userId]
    );
    const [[counts]] = await pool.query<DbRow[]>(
      `SELECT
         SUM(status='open')        AS total_offers,
         SUM(status='in_progress') AS active,
         SUM(status='completed')   AS completed
       FROM offers WHERE influencer_user_id = ?`,
      [userId]
    );
    const [campaigns] = await pool.query<DbRow[]>(
      `SELECT o.id, o.title, o.deadline, o.status, o.target_views, o.target_likes, o.target_shares,
              bp.brand_name, bp.logo_url
       FROM offers o
       JOIN brand_profiles bp ON bp.user_id = o.brand_user_id
       WHERE o.influencer_user_id = ?
       ORDER BY o.created_at DESC LIMIT 5`,
      [userId]
    );
    const [earningsList] = await pool.query<DbRow[]>(
      'SELECT id, description, amount, created_at FROM earnings WHERE influencer_user_id = ? ORDER BY created_at DESC LIMIT 10',
      [userId]
    );
    return {
      followers_count: (profile as { followers_count?: number })?.followers_count ?? 0,
      engagement_rate: (profile as { engagement_rate?: number })?.engagement_rate ?? 0,
      total_earnings: (earnings as { total?: number })?.total ?? 0,
      total_offers: (counts as { total_offers?: number })?.total_offers ?? 0,
      active_campaigns: (counts as { active?: number })?.active ?? 0,
      completed_campaigns: (counts as { completed?: number })?.completed ?? 0,
      campaigns,
      earnings: earningsList,
    };
  },

  async brandOverview(userId: number) {
    const [[counts]] = await pool.query<DbRow[]>(
      `SELECT
         COUNT(DISTINCT o.influencer_user_id) AS creators_hired,
         COALESCE(SUM(o.budget),0)              AS total_reach,
         COUNT(o.id)                            AS campaigns_created
       FROM offers o WHERE o.brand_user_id = ?`,
      [userId]
    );
    const [[perf]] = await pool.query<DbRow[]>(
      `SELECT
         AVG(ip.engagement_rate) AS avg_engagement,
         COALESCE(SUM(ip.followers_count),0) AS total_followers
       FROM offers o
       JOIN influencer_profiles ip ON ip.user_id = o.influencer_user_id
       WHERE o.brand_user_id = ?`,
      [userId]
    );
    const [rooms] = await pool.query<DbRow[]>(
      `SELECT o.id, o.title, o.deadline, o.status, o.target_views, o.target_likes, o.target_shares,
              ip.username AS influencer_username, u.name AS influencer_name
       FROM offers o
       JOIN influencer_profiles ip ON ip.user_id = o.influencer_user_id
       JOIN users u ON u.id = o.influencer_user_id
       WHERE o.brand_user_id = ?
       ORDER BY o.created_at DESC LIMIT 5`,
      [userId]
    );
    return {
      creators_hired: (counts as { creators_hired?: number })?.creators_hired ?? 0,
      total_reach: (counts as { total_reach?: number })?.total_reach ?? 0,
      campaigns_created: (counts as { campaigns_created?: number })?.campaigns_created ?? 0,
      avg_engagement: Number(((perf as { avg_engagement?: number })?.avg_engagement ?? 0).toFixed(2)),
      total_followers: (perf as { total_followers?: number })?.total_followers ?? 0,
      rooms,
    };
  },
};
