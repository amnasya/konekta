# Konekta — Setup Guide

Panduan lengkap untuk menjalankan aplikasi Konekta secara lokal.

---

## Prerequisites

Pastikan semua tools berikut sudah terinstall:

| Tool | Versi Minimum | Download |
|------|--------------|---------|
| Node.js | 18+ | https://nodejs.org |
| npm | 9+ | (bundled dengan Node.js) |
| MySQL | 8.0+ | https://dev.mysql.com/downloads |
| Flutter | 3.10+ (Dart SDK ^3.10.8) | https://flutter.dev/docs/get-started/install |
| Git | any | https://git-scm.com |

---

## 1. Clone Repository

```bash
git clone <repo-url>
cd konekta-project
```

---

## 2. Setup Database

### 2.1 Buat Database

Buka MySQL client (MySQL Workbench, DBeaver, atau terminal):

```sql
CREATE DATABASE konekta CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

### 2.2 Import Schema & Seed Data

```bash
mysql -u root -p konekta < database/schema.sql
```

> Perintah ini akan membuat semua tabel dan mengisi data awal (seed).

### 2.3 Verifikasi

```sql
USE konekta;
SHOW TABLES;
```

Pastikan tabel berikut ada:
- `users`, `influencer_profiles`, `brand_profiles`
- `offers`, `campaign_applicants`, `submitted_videos`
- `video_daily_stats`, `earnings`, `notifications`
- `conversations`, `messages`, `social_media_accounts`

---

## 3. Setup Backend

### 3.1 Install Dependencies

```bash
cd backend
npm install
```

### 3.2 Konfigurasi Environment

Buat file `.env` di folder `backend/`:

```bash
cp backend/.env.example backend/.env
```

Atau buat manual dengan isi berikut:

```env
# Server
PORT=4000

# Database
DB_HOST=127.0.0.1
DB_PORT=3306
DB_USER=root
DB_PASSWORD=your_mysql_password
DB_NAME=konekta

# JWT
JWT_SECRET=your-secret-key-ganti-ini
TOKEN_EXPIRY_HOURS=24

# RapidAPI TikTok (untuk fetch video stats)
RAPIDAPI_KEY=your_rapidapi_key
RAPIDAPI_TIKTOK_HOST=tiktok-api23.p.rapidapi.com

# Google OAuth (opsional)
GOOGLE_CLIENT_ID=
GOOGLE_CLIENT_SECRET=
GOOGLE_REDIRECT_URI=http://localhost:4000/auth/google/callback
```

> **Cara dapat RAPIDAPI_KEY:**
> 1. Daftar di https://rapidapi.com
> 2. Search "TikTok API" → Subscribe ke plan Free
> 3. Copy `X-RapidAPI-Key` dari halaman endpoint

### 3.3 Jalankan Backend

**Development (auto-reload):**
```bash
cd backend
npm run dev
```

**Production (build dulu):**
```bash
cd backend
npm run build
npm start
```

Backend berjalan di: `http://localhost:4000`

### 3.4 Verifikasi Backend

Buka browser atau Postman:
```
GET http://localhost:4000/health
```

Response yang diharapkan:
```json
{ "success": true, "message": "Konekta API is running" }
```

---

## 4. Setup Flutter App

### 4.1 Install Flutter Dependencies

```bash
cd konekta
flutter pub get
```

### 4.2 Konfigurasi API URL

Buka file `konekta/lib/core/api_client.dart` dan pastikan `baseUrl` mengarah ke backend:

- **Emulator Android:** `http://10.0.2.2:4000`
- **Emulator iOS / Simulator:** `http://127.0.0.1:4000`
- **Device fisik:** `http://<IP-komputer-kamu>:4000`

### 4.3 Jalankan Flutter App

```bash
cd konekta
flutter run
```

Pilih device yang tersedia (emulator atau device fisik).

---

## 5. Akun Test

Setelah import `schema.sql`, akun berikut tersedia:

| Role | Email | Password |
|------|-------|----------|
| Influencer | ava@konekta_mobile_app.test | password123 |
| Influencer | leo@konekta_mobile_app.test | password123 |
| Influencer | maya@konekta_mobile_app.test | password123 |
| Brand | brand1@konekta_mobile_app.test | password123 |
| Brand | brand2@konekta_mobile_app.test | password123 |
| Brand | brand3@konekta_mobile_app.test | password123 |

---

## 6. Struktur Folder

```
konekta-project/
├── backend/              # Express.js + TypeScript API
│   ├── src/
│   │   ├── controllers/  # HTTP handlers
│   │   ├── services/     # Business logic
│   │   ├── routes/       # Route definitions
│   │   ├── models/       # Data models
│   │   └── config/       # DB & env config
│   ├── .env              # Environment variables (jangan di-commit)
│   └── package.json
│
├── konekta/              # Flutter mobile app
│   ├── lib/
│   │   ├── auth/         # Login, register, role select
│   │   ├── brand/        # Brand dashboard, explore, analytics
│   │   ├── influencer/   # Influencer dashboard, explore, analytics
│   │   ├── campaign/     # Campaign room screen
│   │   ├── data/         # Models & repositories
│   │   └── core/         # Theme, API client, utilities
│   └── pubspec.yaml
│
└── database/
    ├── schema.sql         # Struktur tabel + seed data
    └── seed.sql           # Data tambahan (opsional)
```

---

## 7. Troubleshooting

### Backend tidak bisa connect ke DB
- Pastikan MySQL berjalan: `sudo service mysql start` (Linux) atau lewat MySQL Workbench
- Cek `DB_HOST`, `DB_PORT`, `DB_USER`, `DB_PASSWORD` di `.env`
- Pastikan database `konekta` sudah dibuat

### Flutter tidak bisa connect ke backend
- Pastikan backend berjalan di port 4000
- Untuk emulator Android, gunakan `10.0.2.2` bukan `localhost`
- Untuk device fisik, pastikan HP dan komputer di jaringan WiFi yang sama, gunakan IP komputer

### Error 500 di analytics
- Pastikan tabel `video_daily_stats` sudah ada di DB
- Jalankan ulang `schema.sql` atau buat manual tabelnya

### TikTok API error 429 (rate limit)
- API key sudah mencapai limit harian
- Ganti dengan API key baru dari RapidAPI atau tunggu reset limit
- Video tetap tersimpan, klik tombol refresh (↺) di video card setelah limit reset

### TikTok API error 422
- Pastikan URL video TikTok lengkap, format: `https://www.tiktok.com/@username/video/1234567890`
- URL harus mengandung `/video/` dan numeric ID

---

## 8. Environment Variables Reference

| Variable | Keterangan | Contoh |
|----------|-----------|--------|
| `PORT` | Port backend | `4000` |
| `DB_HOST` | Host MySQL | `127.0.0.1` |
| `DB_PORT` | Port MySQL | `3306` |
| `DB_USER` | Username MySQL | `root` |
| `DB_PASSWORD` | Password MySQL | `mypassword` |
| `DB_NAME` | Nama database | `konekta` |
| `JWT_SECRET` | Secret untuk JWT token | string acak panjang |
| `TOKEN_EXPIRY_HOURS` | Durasi token (jam) | `24` |
| `RAPIDAPI_KEY` | API key dari RapidAPI | dari dashboard RapidAPI |
| `RAPIDAPI_TIKTOK_HOST` | Host TikTok API | `tiktok-api23.p.rapidapi.com` |
