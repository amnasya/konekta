import axios from 'axios';

export interface TikTokStats {
  views: number;
  likes: number;
  shares: number;
  comments: number;
  title: string;
  author: string;
}

const RAPIDAPI_KEY  = process.env.RAPIDAPI_KEY ?? '';
const RAPIDAPI_HOST = process.env.RAPIDAPI_TIKTOK_HOST ?? 'tiktok-api23.p.rapidapi.com';

/**
 * Extract numeric video ID from a TikTok URL.
 * Handles: https://www.tiktok.com/@user/video/7306132438047116586
 */
function extractVideoId(url: string): string {
  const match = url.match(/\/video\/(\d+)/);
  if (!match?.[1]) {
    throw new Error('Cannot extract video ID from URL. Make sure it is a full TikTok video URL (e.g. https://www.tiktok.com/@user/video/123456)');
  }
  return match[1];
}

/**
 * Fetch TikTok video stats via RapidAPI tiktok-api23.
 *
 * Endpoint: GET /api/post/detail?videoId={id}
 * Response: itemInfo.itemStruct.stats
 *   playCount  → views
 *   diggCount  → likes
 *   shareCount → shares
 */
export async function fetchTikTokStats(videoUrl: string): Promise<TikTokStats> {
  const cleanUrl = videoUrl.split('?')[0].trim();
  const videoId  = extractVideoId(cleanUrl);

  const result: TikTokStats = {
    views: 0, likes: 0, shares: 0, comments: 0, title: '', author: '',
  };

  const res = await axios.get(`https://${RAPIDAPI_HOST}/api/post/detail`, {
    params: { videoId },
    headers: {
      'x-rapidapi-key':  RAPIDAPI_KEY,
      'x-rapidapi-host': RAPIDAPI_HOST,
      'Content-Type':    'application/json',
    },
    timeout: 12000,
  });

  const itemStruct = res.data?.itemInfo?.itemStruct;
  if (!itemStruct) {
    throw new Error('Unexpected response from TikTok API');
  }

  const stats = itemStruct.stats ?? {};
  result.views    = Number(stats.playCount    ?? 0);
  result.likes    = Number(stats.diggCount    ?? 0);
  result.shares   = Number(stats.shareCount   ?? 0);
  result.comments = Number(stats.commentCount ?? 0);
  result.title    = (itemStruct.desc ?? itemStruct.contents?.[0]?.desc ?? '').slice(0, 200);
  result.author   = itemStruct.author?.nickname ?? itemStruct.author?.uniqueId ?? '';

  return result;
}
