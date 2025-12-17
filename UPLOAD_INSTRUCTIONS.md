Panduan penggunaan kode (Siap dijalankan lokal)

Repository ini berisi kode aplikasi Flutter dan file proyek yang diperlukan agar orang lain bisa meng-clone dan menjalankan aplikasi di perangkat mereka.

Catatan penting sebelum mulai:

- Backend PHP dan file server tidak disertakan. Minta file backend dari pemilik proyek jika diperlukan.
- File kredensial Firebase (`google-services.json` untuk Android, `GoogleService-Info.plist` untuk iOS) dan keystore tidak disertakan di repo untuk alasan keamanan. Tempatkan file tersebut sendiri jika diperlukan.

Langkah cepat untuk menjalankan lokal:

1. Clone repo:

   git clone https://github.com/hadiahtv9-tech/aplikasi-sistem-informasi-sekolah-sma-dengan-flutter.git
   cd aplikasi-sistem-informasi-sekolah-sma-dengan-flutter

2. Checkout branch yang berisi kode siap-jalankan:

   git checkout dart-ready

3. Siapkan environment:

   - Install Flutter SDK: https://flutter.dev/docs/get-started/install
   - Jalankan `flutter doctor` dan perbaiki masalah jika ada.

4. Tambahkan file konfigurasi (jika diperlukan):

   - Letakkan `android/app/google-services.json` jika menggunakan Firebase Android.
   - Letakkan `ios/GoogleService-Info.plist` jika menggunakan Firebase iOS.
   - Jika aplikasi memanggil backend PHP, tempatkan backend di mesin pengembang (contoh: jalankan PHP built-in server atau XAMPP) lalu sesuaikan URL API di kode sumber.

5. Instal dependency dan jalankan aplikasi:

   flutter pub get
   flutter run

6. Menjalankan backend PHP (contoh cepat):

   - Jika Anda punya folder backend PHP, jalankan dari folder tersebut:

     php -S localhost:8000 -t public/

   - Atur URL API di konfigurasi aplikasi (cari `baseUrl` atau file konfigurasi API di `lib/`), lalu jalankan kembali aplikasi Flutter.

7. Jika ingin berbagi build yang siap install (APK):

   - Pemilik proyek dapat membangun APK dengan `flutter build apk --release` dan mengunggah hasilnya ke branch `dart-release` atau meletakkannya di halaman Releases GitHub.

Jika butuh bantuan menyesuaikan URL API atau menambahkan instruksi khusus, hubungi pemilik proyek.
