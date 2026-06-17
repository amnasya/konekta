# MASTER TODO — Konekta (Deploy Ready)

> Status terakhir diperbarui setelah sesi fix otomatis.
> ✅ = selesai | 🔲 = belum dikerjakan

---

## Status Ringkasan

| Layer | Status |
|---|---|
| Flutter (screens & models) | ✅ Lengkap |
| Database schema | ✅ Lengkap (semua tabel & kolom ada) |
| Backend services | ✅ Diperbaiki |
| Backend endpoints | ✅ Semua path sudah cocok dengan Flutter |
| Google Auth | ✅ Direfactor — pakai JWT, tidak bergantung bearer_tokens table |
| Production hardening | ✅ Rate limit, CORS, error handler, env validation |
| Flutter delete method | ✅ Ditambahkan di api_client.dart |
| Social routes | ✅ Dimount di app.ts |
| Integrasi end-to-end | 🔲 Perlu manual test |
| Deploy config | 🔲 Isi .env production & pilih hosting |

---

## ✅ FASE 1 — Database (SELESAI)

Schema sudah lengkap dengan semua tabel yang dibutuhkan:
- `campaign_applicants` — sudah ada kolom `message`, `proposed_rate`
- `offer_progress` — sudah ada
- `brand_subscriptions` — sudah ada
- `conversations` — sudah ada kolom `last_message`, `last_message_at`
- `notifications` — sudah ada kolom `data`, `is_read`

---

## ✅ FASE 2 — Backend Services (SELESAI)

| File | Status | Perubahan |
|---|---|---|
| `services/offer.service.ts` | ✅ | Sudah benar — kolom sesuai schema |
| `services/analytics.service.ts` | ✅ | Sudah benar — query dari `offers`, bukan `campaigns` |
| `services/chat.service.ts` | ✅ | Sudah benar — pakai `message_text` |
| `services/notification.service.ts` | ✅ | Sudah benar — pakai `is_read` |
| `services/dashboard.service.ts` | ✅ | Sudah benar — query influencer dari `campaign_applicants`, brand include `recent_campaigns` & `stats` |
| `services/discovery.service.ts` | ✅ | Sudah benar — tidak ada JOIN ke `campaigns` |
| `services/subscription.service.ts` | ✅ | **DIFIX** — pakai `brand_subscriptions`, plans hardcoded, terima `plan_id` |
| `modules/offers/offer.service.ts` | ✅ | **DIFIX** — `influencer_user_id` nullable, query influencer dari `campaign_applicants` |

---

## ✅ FASE 3 — Endpoint Alignment (SELESAI)

| Endpoint | Status |
|---|---|
| `POST /offers/:id/applicants` (Flutter) → mapped ke `offerController.apply` | ✅ |
| `GET /subscriptions/me` | ✅ Route ada |
| `GET /subscriptions/mine` | ✅ Alias ke `/me` |
| `POST /conversations` terima `{ other_user_id }` | ✅ |
| `POST /conversations/ensure` (legacy) | ✅ Masih ada |
| `POST /notifications/:id/read` | ✅ Route ada |
| `GET /offers` return flat array | ✅ `listPublic` return array langsung |
| `GET /offers/mine` handle brand + influencer | ✅ |
| `GET /dashboard/brand` include `recent_campaigns` & `stats` | ✅ |
| `GET /dashboard/influencer` query dari `campaign_applicants` | ✅ |
| `applicants_count` di response offers | ✅ Subquery ada di semua list query |
| `GET /conversations` include `other_user_name`, `other_user_avatar_url` | ✅ JOIN ke users sudah ada |
| `GET /conversations/:id/messages` include `is_mine` | 🔲 Perlu ditambah (lihat bawah) |
| `POST /social` routes dimount | ✅ Dimount di `/social` |

---

## ✅ FASE 4 — Production Hardening (SELESAI)

| Item | Status |
|---|---|
| Rate limiting auth endpoints | ✅ In-memory limiter di `app.ts` |
| CORS whitelist via `ALLOWED_ORIGINS` env | ✅ |
| Error handler tidak expose stack trace di production | ✅ |
| JWT_SECRET validation saat startup di production | ✅ `env.ts` exit(1) jika default |
| Google OAuth controller pakai JWT (tidak bergantung `bearer_tokens` table) | ✅ |
| `INTERNET` permission di AndroidManifest | ✅ Sudah ada |
| `delete` method di `api_client.dart` Flutter | ✅ Ditambahkan |

---

## 🔲 Yang Masih Perlu Dikerjakan

### 1. Tambah `is_mine` di messages response

File: `backend/src/services/chat.service.ts`, method `listMessages`

```typescript
// Ganti query ini:
`SELECT id, conversation_id, sender_user_id, message_text AS body, attachment_url, created_at
   FROM messages WHERE conversation_id = ? ORDER BY created_at ASC`

// Menjadi:
`SELECT id, conversation_id, sender_user_id, message_text AS body, attachment_url, created_at,
        (sender_user_id = ?) AS is_mine
   FROM messages WHERE conversation_id = ? ORDER BY created_at ASC`
// params: [userId, conversationId]
```

### 2. Isi `.env` untuk production

Salin `.env.example` → `.env` dan isi:
```
NODE_ENV=production
DB_HOST=<host database production>
DB_PASSWORD=<password>
JWT_SECRET=<random string panjang, min 32 karakter>
GOOGLE_CLIENT_ID=<dari Google Cloud Console, jika pakai Google Sign-In>
ALLOWED_ORIGINS=https://yourdomain.com
```

### 3. Jalankan `schema.sql` di database production

```bash
mysql -u <user> -p < database/schema.sql
```
Jangan jalankan `seed.sql` di production.

### 4. Build Flutter release APK

```bash
flutter build apk --release \
  --dart-define=API_BASE_URL=https://your-backend-url.com
```

Atau untuk Android App Bundle:
```bash
flutter build appbundle --release \
  --dart-define=API_BASE_URL=https://your-backend-url.com
```

### 5. Deploy backend

Pilihan paling mudah:
- **Railway**: connect repo → set env vars → deploy otomatis
- **Render**: create Web Service → set env vars → build command `npm run build` → start `npm start`

Pastikan `package.json` scripts:
```json
"build": "tsc -p tsconfig.json",
"start": "node dist/server.js"
```

### 6. Setup HTTPS/SSL

- Railway & Render: otomatis dapat HTTPS
- Jika VPS: pasang Nginx + Certbot (Let's Encrypt)

### 7. Manual End-to-End Testing

Setelah deploy, test flow ini di device fisik:
1. Register sebagai influencer → complete profile
2. Register sebagai brand → complete profile
3. Brand buat offer → influencer apply → brand approve
4. Chat antara brand & influencer
5. Check notifikasi muncul
6. Brand lihat dashboard & analytics
7. Brand subscribe ke plan
8. Influencer lihat dashboard & analytics

---

## Catatan untuk Developer

- Backend dev server: `cd backend && npm run dev`
- Reset DB: `npm run db:reset` (hati-hati — DROP DATABASE!)
- Flutter dev: `flutter run --dart-define=API_BASE_URL=http://10.0.2.2:4000` (Android emulator)
- Flutter dev iOS: `flutter run --dart-define=API_BASE_URL=http://localhost:4000`
