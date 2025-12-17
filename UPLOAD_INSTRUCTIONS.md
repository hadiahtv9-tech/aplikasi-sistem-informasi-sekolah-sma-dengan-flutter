Panduan penggunaan kode (Dart-only)

Repository ini berisi hanya kode aplikasi Flutter (file .dart) dari proyek.

Langkah cepat untuk teman:

1. Clone repo:

   git clone https://github.com/hadiahtv9-tech/aplikasi-sistem-informasi-sekolah-sma-dengan-flutter.git
   cd aplikasi-sistem-informasi-sekolah-sma-dengan-flutter

2. Checkout branch yang berisi kode Dart:

   git checkout dart-only

3. Pasang Flutter (jika belum):

   - Install Flutter SDK sesuai panduan resmi: https://flutter.dev/docs/get-started/install
   - Pastikan `flutter doctor` bersih atau perbaiki masalah yang dilaporkan.

4. Instal dependency dan jalankan:

   flutter pub get
   flutter run

5. Catatan penting:

- Backend PHP dan file server tidak disertakan di branch ini — mereka ada di workspace lain.
- Jika aplikasi membutuhkan konfigurasi Firebase (google-services.json atau GoogleService-Info.plist), minta file tersebut dari pemilik proyek atau tambahkan konfigurasi sendiri.
- Jika ada konfigurasi environment (API URL, token), periksa file sumber dan tambahkan nilai yang sesuai.

6. Jika ingin kontribusi atau perubahan besar:

   - Buat branch baru dari `dart-only`.
   - Ajukan pull request ke repository upstream.

Kontak jika perlu bantuan: hubungi pemilik repo.
