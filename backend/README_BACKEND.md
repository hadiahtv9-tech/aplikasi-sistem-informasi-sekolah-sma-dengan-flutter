Backend README — Import database & jalankan API

Lokasi file SQL di repo:
- backend/flutter_api/sql/flutter_uas.sql

1) Import database (MySQL/MariaDB)

- Buat database:

  mysql -u root -p -e "CREATE DATABASE IF NOT EXISTS flutter_uas CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"

- Import dump:

  mysql -u root -p flutter_uas < backend/flutter_api/sql/flutter_uas.sql

Alternatif: gunakan phpMyAdmin atau MySQL Workbench untuk import file SQL.

2) Konfigurasi kredensial database

- Salin file contoh `backend/flutter_api/.env.example` menjadi `backend/flutter_api/.env` dan isi nilai:

  DB_HOST=127.0.0.1
  DB_NAME=flutter_uas
  DB_USER=root
  DB_PASS=your_password

- `db.php` sudah ditulis untuk membaca environment variables. Anda bisa mengekspor variabel environment atau menggunakan tool seperti `phpdotenv` jika perlu.

Contoh mengekspor di Linux/macOS:

  export DB_HOST=127.0.0.1
  export DB_NAME=flutter_uas
  export DB_USER=root
  export DB_PASS=your_password

Contoh untuk PowerShell (Windows):

  $env:DB_HOST = "127.0.0.1"
  $env:DB_NAME = "flutter_uas"
  $env:DB_USER = "root"
  $env:DB_PASS = "your_password"

3) Menjalankan server PHP (pengembangan)

- Menggunakan PHP built-in server (dari root project):

  cd backend/flutter_api
  php -S 0.0.0.0:8000

API akan tersedia di `http://localhost:8000/`.

- Jika menggunakan XAMPP/WAMP/IIS, letakkan folder `backend/flutter_api` di `htdocs` atau konfigurasi virtual host sesuai kebutuhan.

4) Menjalankan aplikasi Flutter melawan backend lokal

- Untuk Android emulator (Android Studio): gunakan `http://10.0.2.2:8000/` sebagai base URL (emulator memetakan host machine ke alamat ini).
- Untuk iOS Simulator: gunakan `http://localhost:8000/`.
- Untuk perangkat fisik: pastikan perangkat dan host berada pada jaringan yang sama, lalu gunakan alamat IP host (mis. `http://192.168.1.100:8000/`).

Cari konfigurasi base URL di aplikasi Flutter: periksa `lib/services` atau file yang berisi `baseUrl`.

5) Keamanan dan catatan

- Jangan commit file `backend/flutter_api/.env` ke repo. `.gitignore` sudah mengabaikannya.
- Jangan commit kredensial atau file keystore.
- Jika ingin membagikan dump DB secara publik, pastikan data sensitif telah dihapus/anonymized.

6) Troubleshooting

- Jika API mengembalikan error koneksi DB, cek bahwa MySQL berjalan dan env vars sudah ter-set.
- Periksa `backend/flutter_api/test_db.php` atau `health.php` untuk endpoint pengecekan cepat.

Jika Anda mau, saya bisa langsung men-commit file SQL yang sudah ada (saat ini di `backend/flutter_api/sql/flutter_uas.sql`) dan mem-push ke branch `with-backend` (atau buat branch baru).