class ApiConfig {
  /// - Android emulator: keep default `http://10.0.2.2:8080`
  /// - Physical Android device over USB: use `adb reverse` and set
  ///   `flutter run -d 00256663S002302 --dart-define=TEKACHI_API_BASE_URL=http://127.0.0.1:8080`
  /// - Physical device over Wi‑Fi: set to your computer's LAN IP
  ///   (e.g. `http://192.168.1.10:8080`)
  static const String baseUrl = String.fromEnvironment(
    'TEKACHI_API_BASE_URL',
    defaultValue: 'http://10.0.2.2:8080', //emulator ip
  );
}
