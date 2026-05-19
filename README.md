# Konekta 🤝

**Platform Mobile untuk Kolaborasi Influencer & Brand**

Konekta adalah aplikasi mobile berbasis Flutter yang menghubungkan influencer dengan brand dalam satu ekosistem kampanye digital yang terintegrasi. Influencer dapat menemukan, mendaftar, dan memantau kampanye secara real-time, sementara brand dapat mengelola kampanye serta melihat performa dari dalam aplikasi.

---

## Fitur Utama

### Untuk Influencer
- **Dashboard Pribadi** — Pantau pendapatan bulan ini, saldo tertunda (pending), total views, dan engagement dalam satu halaman
- **Manajemen Kampanye** — Lihat daftar kampanye aktif beserta progress, target views/engagement, sisa hari, dan status
- **Explore Kampanye** — Temukan kampanye yang tersedia dari berbagai brand, lengkap dengan detail budget, platform, dan minimum followers
- **Apply Kampanye** — Daftar ke kampanye yang diminati langsung dari halaman detail
- **Detail Kampanye** — Akses informasi lengkap: deskripsi, budget, deliverables, platform, tipe konten, dan status aplikasi

### Untuk Brand
- **Brand Dashboard** — Pantau performa seluruh kampanye yang sedang berjalan
- **Brand Explore** — Kelola influencer yang berpartisipasi dalam kampanye
- **Brand Analytics** — Analitik mendalam terkait performa kampanye aktif
- **Manajemen Profil Brand** — Kelola informasi dan identitas brand

### Umum
- **Onboarding Interaktif** — Tampilan 3 slide pengantar fitur utama aplikasi
- **Pemilihan Peran** — Pengguna memilih peran (Influencer / Brand) saat pertama kali mendaftar
- **Sistem Autentikasi** — Alur registrasi dan login yang lengkap, termasuk layar konfirmasi pembuatan akun
- **Health Check API** — Endpoint `/health` untuk memantau status server

---

## Tech Stack

| Layer | Teknologi | Versi |
|---|---|---|
| Mobile App | Flutter (Dart) | SDK ^3.10.8 |
| State Management | Provider | ^6.1.2 |
| HTTP Client | Dio | ^5.7.0 |
| Backend | Node.js + Express + TypeScript | Express ^4.19.2 |
| Database Driver | mysql2 | ^3.9.7 |
| Database | MySQL | >= 8.x |
| Font | Google Fonts (Poppins) | ^6.2.1 |
| Icons | Lucide Icons | ^0.257.0 |

---

## Struktur Proyek

```
konekta-main/
├── konekta/                        # Flutter mobile app
│   └── lib/
│       ├── main.dart               # Entry point aplikasi
│       ├── models/                 # Data models
│       │   ├── campaign_detail_model.dart
│       │   ├── dashboard_model.dart
│       │   ├── explore_model.dart
│       │   └── user_role.dart
│       ├── providers/
│       │   └── dashboard_provider.dart
│       ├── screens/
│       │   ├── auth/               # Onboarding, Login, Signup, Role Selection, dll.
│       │   ├── influencer/         # Dashboard, Explore, Campaign Detail, Profile
│       │   ├── brand/              # Brand Dashboard, Explore, Analytics, Profile
│       │   └── shells/             # Bottom navigation shell per peran
│       ├── services/               # API layer
│       │   ├── campaign_service.dart
│       │   ├── dashboard_service.dart
│       │   └── explore_service.dart
│       ├── theme/
│       │   └── app_colors.dart
│       └── widgets/                # Reusable widgets
│           └── dashboard/          # Earnings card, campaign list, header, search bar
│
├── backend/                        # Node.js + Express API
│   ├── src/
│   │   ├── index.ts                # Entry point & konfigurasi server
│   │   ├── db.ts                   # Koneksi MySQL (connection pool)
│   │   ├── routes/
│   │   │   ├── dashboard.ts        # Endpoint dashboard & statistik
│   │   │   ├── campaign.ts         # Endpoint detail & apply kampanye
│   │   │   └── explore.ts          # Endpoint explore kampanye & brand
│   │   └── types/                  # TypeScript type definitions
│   └── database/
│       ├── schema.sql              # Skema database utama
│       └── campaign_detail_migration.sql
│
└── database/
    └── konekta.sql                 # Full database dump
```

---

## Prasyarat

Pastikan tools berikut sudah terinstal sebelum menjalankan proyek:

- [Flutter SDK](https://docs.flutter.dev/get-started/install) >= 3.x
- [Node.js](https://nodejs.org/) >= 18.x
- [MySQL](https://dev.mysql.com/downloads/) >= 8.x
- [Git](https://git-scm.com/)

---

## Instalasi & Menjalankan Proyek

### 1. Clone Repository

```bash
git clone https://github.com/amnasya/konekta.git
cd konekta-main
```

---

### 2. Setup Database

Buka MySQL client, lalu jalankan full dump yang sudah tersedia:

```bash
mysql -u root -p < database/konekta.sql
```

Atau jalankan skema secara bertahap:

```bash
mysql -u root -p < backend/database/schema.sql
mysql -u root -p konekta < backend/database/campaign_detail_migration.sql
```

Database `konekta` akan dibuat secara otomatis beserta seluruh tabel dan data seed awal.

---

### 3. Setup Backend (Node.js)

```bash
cd backend
npm install
```

Buat file `.env` di dalam folder `backend/`:

```env
PORT=3000
DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASSWORD=your_password
DB_NAME=konekta
```

Jalankan backend server:

```bash
# Mode development (auto-reload)
npm run dev

# Build TypeScript ke JavaScript
npm run build

# Mode production (setelah build)
npm start
```

Server akan berjalan di `http://localhost:3000`

Verifikasi server aktif dengan membuka:

```
GET http://localhost:3000/health
```

Response yang diharapkan:
```json
{ "status": "ok", "timestamp": "2025-01-01T00:00:00.000Z" }
```

---

### 4. Setup Flutter App

```bash
cd ../konekta
flutter pub get
```

Pastikan base URL API di folder `lib/services/` sudah mengarah ke alamat backend yang benar:
- Emulator Android: `http://10.0.2.2:3000`
- Perangkat fisik: gunakan IP lokal mesin backend (contoh: `http://192.168.1.x:3000`)

Jalankan aplikasi:

```bash
# Cek perangkat yang tersedia
flutter devices

# Jalankan di perangkat/emulator
flutter run
```

Build APK release:

```bash
flutter build apk --release
```

---

## API Endpoints

Semua endpoint menggunakan base URL: `http://localhost:3000`

| Method | Endpoint | Deskripsi |
|---|---|---|
| GET | `/health` | Cek status server |
| GET | `/api/dashboard/:userId` | Data dashboard influencer (earnings, stats, kampanye aktif) |
| GET | `/api/explore` | Daftar semua kampanye dan brand yang tersedia |
| GET | `/api/campaign/:id` | Detail kampanye berdasarkan ID |
| GET | `/api/campaign/:id?userId=x` | Detail kampanye + status sudah apply atau belum |
| POST | `/api/campaign/:id/apply` | Daftarkan influencer ke sebuah kampanye |

### Contoh Response — `GET /api/dashboard/1`

```json
{
  "user": {
    "username": "Amna",
    "thisMonthEarnings": 3467420,
    "pendingBalance": 1250000,
    "totalViews": 24800,
    "engagement": 2300
  },
  "campaigns": [
    {
      "id": 1,
      "title": "Kopi Susu",
      "daysLeft": 5,
      "progress": 75,
      "targetViews": 50000,
      "targetEngagement": 5000,
      "status": "IN PROGRESS"
    }
  ]
}
```

### Contoh Request — `POST /api/campaign/1/apply`

```json
{
  "userId": 1
}
```

---

## Skema Database

```
users                  — Data pengguna (id, username, email, created_at)
brands                 — Data brand (id, name, category, logo_url, verified)
campaigns              — Data kampanye (id, title, description, budget, status, deadline_days, dll.)
campaign_platforms     — Platform per kampanye (Instagram, TikTok, dll.)
campaign_deliverables  — Daftar deliverable per kampanye
campaign_influencers   — Relasi kampanye ↔ influencer
campaign_applications  — Riwayat apply influencer ke kampanye
payments               — Riwayat pembayaran (amount, status: paid/pending, month, year)
stats                  — Statistik performa influencer (views, engagement)
```

---

## Alur Navigasi Aplikasi

```
Splash Screen
    └── Onboarding (3 slide)
            └── Welcome Screen
                    ├── Login
                    │       ├── Influencer Shell → Dashboard / Explore / Profile
                    │       └── Brand Shell     → Dashboard / Explore / Analytics / Profile
                    └── Register
                            └── Email → Password → Role Selection → Signup → Account Created → Login
```

---

## Mata Kuliah

> Mobile Hybrid Solutions (COSC6094) — BINUS University
