# Al-Quran App

Aplikasi mobile/desktop Al-Quran berbasis **Flutter** dengan **Clean Architecture**, data dari [EQuran API](https://equran.id), dan state management **Riverpod**.

## Fitur

- **Daftar 114 surah** — cari surah berdasarkan nama Latin/Arab/arti
- **Detail surah** — teks Arab, transliterasi Latin, dan terjemahan Indonesia per ayat
- **Audio murottal per ayat** — putar, jeda, dan lanjutkan; 6 pilihan qari
- **Tafsir** — tampilan tafsir per surah (tombol di AppBar detail surah)
- **Bookmark ayat** — simpan ayat favorit secara lokal (Hive)
- **Terakhir dibaca** — lacak surah terakhir yang dibuka
- **Mode gelap** — tema terang/gelap
- **Bagikan ayat** — salin teks Arab + terjemahan ke clipboard
- **Navigasi surah** — loncat ke surah sebelumnya/selanjutnya

## Tech Stack

| Kategori | Paket |
|----------|--------|
| Framework | Flutter (SDK ^3.11.5) |
| State | flutter_riverpod |
| HTTP | dio |
| Audio | just_audio, just_audio_windows |
| Lokal | hive, shared_preferences |
| Lainnya | equatable, google_fonts, intl |

## Arsitektur

Proyek mengikuti **Clean Architecture** dengan pemisahan layer:

```
lib/
├── core/           # Konstanta, tema, network, widget umum, utils
├── data/           # Model, datasource (remote & local), repository impl
├── domain/         # Entity, repository interface, use case
├── presentation/   # Halaman, provider (Riverpod), routing
└── injection/      # Dependency injection (ProviderContainer)
```

Alur data: **UI → Provider → Use Case → Repository → Data Source → API / Hive**

## Struktur Folder (ringkas)

```
lib/
├── core/
│   ├── constants/      # API, tema, teks UI
│   ├── network/        # Dio client & ApiService
│   ├── utils/
│   └── widgets/
├── data/
│   ├── datasource/
│   ├── models/
│   └── repositories/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
├── presentation/
│   ├── pages/
│   ├── providers/
│   └── routes/
├── injection/
└── main.dart
```

## Prasyarat

- [Flutter SDK](https://docs.flutter.dev/get-started/install) ^3.11.5
- Editor (VS Code / Android Studio) — opsional
- Koneksi internet (data surah & audio di-stream dari CDN)
- **Windows:** Visual Studio dengan workload *Desktop development with C++* (untuk build desktop)

## Instalasi & Menjalankan

```bash
# Clone / masuk ke folder proyek
cd mobile-apps

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

## Cara Pakai

### Membaca surah

1. Buka tab **Surah** di navigasi bawah.
2. Ketuk kartu surah atau gunakan kolom pencarian.
3. Scroll daftar ayat; gunakan tombol navigasi di bawah untuk pindah surah.

### Audio murottal

1. Di halaman detail surah, ketuk ikon **▶** pada ayat.
2. Pilih qari di **Pengaturan → Qari Murottal** (6 qari tersedia).
3. Ketuk lagi untuk **jeda**; ketuk sekali lagi untuk **lanjut**.
4. Audio diambil dari `cdn.equran.id` — pastikan volume sistem tidak mute dan ada internet.

### Bookmark

1. Ketuk ikon bookmark pada kartu ayat.
2. Lihat daftar di tab **Bookmark**.
3. Ketuk kartu untuk membuka surah; gunakan ▶ untuk memutar audio (jika data audio tersimpan).

### Tafsir

Pada halaman detail surah, ketuk ikon artikel di AppBar untuk beralih antara ayat dan tafsir.

## API

Data Quran dan audio disediakan oleh:

- **Base URL:** `https://equran.id/api/v2`
- **Dokumentasi:** [equran.id](https://equran.id)

Endpoint yang dipakai:

| Endpoint | Keterangan |
|----------|------------|
| `GET /surat` | Daftar semua surah |
| `GET /surat/{nomor}` | Detail surah + ayat + audio per ayat |
| `GET /tafsir/{nomor}` | Tafsir per surah |

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

- Kode aplikasi: proyek akademik / pribadi (`publish_to: 'none'`).
- Konten Al-Quran, terjemahan, tafsir, dan audio: [EQuran.id](https://equran.id).
