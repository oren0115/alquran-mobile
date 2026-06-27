# Al-Quran App

Aplikasi mobile/desktop Al-Quran berbasis **Flutter** dengan data dari [EQuran API](https://equran.id) dan state management **BLoC** (`flutter_bloc`).

**Versi:** 1.1.0+2

## Fitur

- **Beranda** — sapaan, jadwal sholat hari ini, lanjutkan bacaan terakhir, menu cepat, dan surah populer
- **Daftar 114 surah** — cari surah; filter Juz, Makkiyah, Madaniyah, dan Favorit
- **Detail surah** — teks Arab, transliterasi Latin, dan terjemahan Indonesia per ayat
- **Audio murottal per ayat** — putar, jeda, dan lanjutkan; 6 pilihan qari
- **Halaman murottal** — pemutaran ayat dengan kontrol qari dan navigasi ayat
- **Tafsir** — tampilan tafsir per surah (ikon di AppBar detail surah)
- **Bookmark ayat** — simpan ayat favorit secara lokal (Hive)
- **Terakhir dibaca** — lacak surah terakhir yang dibuka
- **Jadwal sholat** — jadwal harian berdasarkan provinsi/kabupaten-kota (Kemenag RI via EQuran)
- **Doa & dzikir** — daftar doa dengan pencarian dan halaman detail

## Tech Stack

| Kategori | Paket |
|----------|--------|
| Framework | Flutter (SDK ^3.11.5) |
| State | flutter_bloc, equatable |
| HTTP | dio |
| Audio | just_audio, just_audio_windows |
| Lokal | hive, hive_flutter, shared_preferences |
| Lainnya | google_fonts, intl |

## Arsitektur

Proyek menggunakan pola **feature-based** dengan pemisahan tanggung jawab:

```
lib/
├── cubit/       # State management (BLoC)
├── models/      # Model data (Surah, Ayat, Doa, Shalat, dll.)
├── pages/       # UI halaman & widget
├── services/    # API, bookmark, settings, service locator
└── main.dart
```

Alur data: **UI → Cubit → Service → API / Hive / SharedPreferences**

### Cubit utama

| Cubit | Fungsi |
|-------|--------|
| `SurahCubit` | Daftar surah, pencarian, filter |
| `DetailSurahCubit` | Detail surah per nomor |
| `TafsirCubit` | Tafsir per surah |
| `AudioCubit` | Pemutaran audio murottal |
| `BookmarkCubit` | Bookmark ayat (Hive) |
| `SettingsCubit` | Qari, lokasi sholat, terakhir dibaca |
| `ShalatCubit` | Jadwal sholat |
| `DoaCubit` | Daftar & detail doa |

## Struktur Folder

```
lib/
├── cubit/
├── models/
├── pages/
│   ├── bookmark/
│   ├── detail_surah/
│   ├── doa/
│   ├── home/
│   ├── murottal/
│   ├── settings/
│   ├── shalat/
│   ├── splash/
│   ├── theme/
│   ├── widgets/
│   └── routes/
├── services/
│   ├── api_constants.dart
│   ├── api_service.dart
│   ├── bookmark_service.dart
│   ├── quran_service.dart
│   ├── shalat_service.dart
│   ├── doa_service.dart
│   ├── settings_service.dart
│   └── service_locator.dart
└── main.dart
```

## Prasyarat

- [Flutter SDK](https://docs.flutter.dev/get-started/install) ^3.11.5
- Editor (VS Code / Android Studio) — opsional
- Koneksi internet (data surah, audio, sholat, dan doa dari server)
- **Windows:** Visual Studio dengan workload *Desktop development with C++* (untuk build desktop)
- **Android:** Android SDK & JDK 17+

## Instalasi & Menjalankan

```bash
# Clone / masuk ke folder proyek
cd al_quran_app

# Ambil dependensi
flutter pub get

# Lihat perangkat yang tersedia
flutter devices

# Jalankan (pilih salah satu)
flutter run -d windows    # Desktop Windows
flutter run -d android    # Android (emulator/perangkat)
flutter run -d chrome     # Web (fitur audio terbatas)
```

Setelah mengubah plugin native (misalnya audio), lakukan **restart penuh** aplikasi (`q` lalu `flutter run` lagi), bukan hanya hot reload.

### Catatan untuk komputer lain

- File `android/local.properties` dibuat otomatis oleh Flutter (jangan di-commit).
- Jika build Android gagal, periksa `android/gradle.properties` — hapus baris `org.gradle.java.home` jika path Java berbeda di mesin baru.

## Cara Pakai

### Navigasi utama

Aplikasi memiliki 4 tab bawah:

| Tab | Fungsi |
|-----|--------|
| **Beranda** | Ringkasan, jadwal sholat, menu cepat |
| **Surah** | Daftar & pencarian 114 surah |
| **Bookmark** | Ayat yang ditandai |
| **Pengaturan** | Qari, lokasi sholat, terakhir dibaca, tentang app |

### Membaca surah

1. Buka tab **Surah**.
2. Ketuk kartu surah atau gunakan kolom pencarian / filter.
3. Scroll daftar ayat; ketuk ikon **▶** pada ayat untuk memutar murottal.

### Audio murottal

1. Di halaman detail surah, ketuk ikon **▶** pada ayat.
2. Pilih qari di tab **Pengaturan → Pilih Qari** (6 qari tersedia).
3. Ketuk lagi untuk **jeda**; ketuk sekali lagi untuk **lanjut**.
4. Audio di-stream dari `cdn.equran.id` — pastikan volume sistem tidak mute dan ada internet.

### Bookmark

1. Ketuk ikon bookmark pada kartu ayat.
2. Lihat daftar di tab **Bookmark**.
3. Ketuk kartu untuk membuka surah; gunakan ▶ untuk memutar audio.

### Tafsir

Pada halaman detail surah, ketuk ikon buku di AppBar untuk beralih antara ayat dan tafsir.

### Jadwal sholat & doa

- **Jadwal sholat:** dari Beranda atau Pengaturan → Lokasi Sholat.
- **Doa & dzikir:** dari menu cepat di Beranda.

## API

Data disediakan oleh [EQuran.id](https://equran.id):

- **Quran v2:** `https://equran.id/api/v2`
- **Doa:** `https://equran.id/api`

| Endpoint | Keterangan |
|----------|------------|
| `GET /surat` | Daftar semua surah |
| `GET /surat/{nomor}` | Detail surah + ayat + audio per ayat |
| `GET /tafsir/{nomor}` | Tafsir per surah |
| `GET /shalat/provinsi` | Daftar provinsi |
| `GET /shalat/kabkota/{provinsi}` | Daftar kab/kota |
| `POST /shalat` | Jadwal sholat harian |
| `GET /doa` | Daftar doa |
| `GET /doa/{id}` | Detail doa |

Audio murottal di-host di CDN: `https://cdn.equran.id/audio-partial/` (per ayat) dan `audio-full/` (surat lengkap).

## Qari Murottal

| Kode | Nama |
|------|------|
| 01 | Abdullah Al-Juhany |
| 02 | Abdul Muhsin Al-Qasim |
| 03 | Abdurrahman As-Sudais |
| 04 | Ibrahim Al-Dossari |
| 05 | Misyari Rasyid Al-Afasy |
| 06 | Yasser Al-Dosari |

## Pengujian

```bash
flutter test
flutter analyze
```

## Catatan Platform

| Platform | Catatan |
|----------|---------|
| **Windows** | Membutuhkan `just_audio_windows`; build ulang setelah `flutter pub get` |
| **Android** | Izin `INTERNET` sudah di `AndroidManifest.xml` |
| **Web** | Audio streaming bisa berbeda perilakunya; disarankan uji di mobile/desktop |

## Lisensi & Kredit

- Kode aplikasi: proyek akademik / pribadi (`publish_to: 'none'`) — dibuat oleh Nyoman.
- Konten Al-Quran, terjemahan, tafsir, audio, jadwal sholat, dan doa: [EQuran.id](https://equran.id).
