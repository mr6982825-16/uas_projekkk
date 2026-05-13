Rencana Pengembangan Aplikasi Al-Qur'an, Hadist, & Doa (Flutter)

Dokumen ini berisi panduan strategis dan daftar fitur untuk membangun aplikasi Islami yang akurat, estetik, dan sesuai standar.

1. Standar Kualitas & Etika Data

Sebelum memulai, aplikasi harus mematuhi standar berikut:

Akurasi Data: Menggunakan database Al-Qur'an dari sumber resmi (misal: Kemenag RI atau King Fahd Complex/Mushaf Madinah).

Autentisitas Hadist: Menyertakan derajat hadist (Sahih, Hasan) dan perawi yang jelas.

Bebas Iklan Mengganggu: Menghindari iklan yang mengandung gambar tidak syar'i atau suara yang memutus kekhusyukan.

Privasi: Tidak menyalahgunakan data lokasi pengguna (hanya untuk jadwal shalat/kiblat).

2. Rencana Kerja (Roadmap)

Fase 1: Riset & Persiapan Data (Minggu 1-2)

Menentukan sumber API/Database (Contoh: api.quran.com atau database lokal JSON/SQLite).

Penyusunan desain UI/UX dengan nuansa islami yang bersih (Clean Design).

Setup proyek Flutter dan arsitektur (Clean Architecture/MVVM).

Fase 2: Pengembangan Fitur Inti - Al-Qur'an (Minggu 3-5)

Implementasi daftar surah dan juz.

Fitur pembaca (Mode List & Mode Mushaf).

Manajemen audio Murattal (Streaming & Offline).

Fase 3: Hadist & Doa (Minggu 6-7)

Integrasi database Hadist Arba'in atau Kutubut Tis'ah.

Kategorisasi doa harian (Hisnul Muslim).

Fase 4: Fitur Penunjang & Utilitas (Minggu 8-9)

Integrasi API Jadwal Shalat berdasarkan GPS.

Kompas Kiblat menggunakan sensor magnetometer.

Notifikasi Adzan.

Fase 5: Pengujian & Validasi (Minggu 10)

Beta Testing: Verifikasi teks ayat oleh orang yang berkompeten (Tashih mandiri/komunitas).

Uji performa di berbagai perangkat Android & iOS.

3. Daftar Fitur Aplikasi

A. Fitur Al-Qur'an

Multi-Mode Reading: Pilihan tampilan per ayat (list) atau per halaman (mushaf standar).

Tafsir & Terjemahan: Dukungan berbagai bahasa dan tafsir (misal: Tafsir Jalalayn atau Kemenag).

Audio Murattal: Player audio dari berbagai Qari internasional dengan fitur repeat per ayat untuk hafalan.

Pencarian Pintar: Mencari kata kunci dalam terjemahan atau teks Arab.

Bookmark & Last Read: Menandai ayat terakhir dibaca atau ayat favorit.

Tajwid Berwarna: (Opsional) Memberikan warna pada teks Arab sesuai hukum tajwid.

B. Fitur Hadist

Koleksi Hadist: Minimal mencakup Hadist Arba'in Nawawi.

Eksplorasi Perawi: Pencarian berdasarkan perawi (Bukhari, Muslim, Tirmidzi, dll).

Share Quote: Fitur membagikan potongan hadist ke media sosial dengan desain kartu yang bagus.

C. Fitur Doa & Dzikir

Dzikir Pagi Petang: Penghitung (tasbih digital) yang terintegrasi dalam teks dzikir.

Kategori Doa: Doa makan, tidur, safar, dll (berdasarkan Hisnul Muslim).

Audio Doa: Membantu pengguna mempelajari pelafalan doa yang benar.

D. Fitur Utilitas (Daily Essentials)

Jadwal Shalat Otomatis: Berdasarkan koordinat GPS pengguna.

Notifikasi Adzan: Suara adzan atau pengingat sebelum waktu shalat tiba.

Kompas Kiblat: Visualisasi arah Ka'bah yang akurat.

Kalender Hijriah: Konversi tanggal masehi ke hijriah.

4. Stack Teknologi yang Direkomendasikan

Framework: Flutter (Stable Channel).

State Management: Bloc atau Provider untuk skalabilitas.

Local Database: SQFlite atau Hive (untuk penyimpanan ayat agar bisa dibaca offline).

API: http atau dio untuk mengambil data jadwal shalat/audio.

Location: geolocator untuk posisi pengguna.

Sensors: flutter_compass untuk fitur kiblat.