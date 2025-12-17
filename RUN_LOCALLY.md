Run locally (Quick Start)

1) Clone and checkout

   git clone https://github.com/hadiahtv9-tech/aplikasi-sistem-informasi-sekolah-sma-dengan-flutter.git
   cd aplikasi-sistem-informasi-sekolah-sma-dengan-flutter
   git checkout dart-ready

2) Requirements

   - Flutter SDK (follow https://flutter.dev/docs/get-started/install)
   - Android Studio or Xcode (optional, for emulators/devices)
   - PHP or local webserver if you will run the PHP backend locally

3) Add missing credentials (if required)

   - Place `android/app/google-services.json` and/or `ios/GoogleService-Info.plist` if using Firebase.
   - Add any API keys or environment files as instructed by the project owner.

4) Run backend (example using PHP built-in server)

   cd path/to/backend
   php -S localhost:8000 -t public/

5) Run Flutter app

   cd path/to/this/repo
   flutter pub get
   flutter run

6) Troubleshooting

   - If the app cannot reach the API, open the relevant file in `lib/services` or search for `baseUrl` and set the correct address (e.g., `http://10.0.2.2:8000` for Android emulator pointing to host).
   - For real devices, ensure device and backend are on the same network or use ngrok/tunnel.
