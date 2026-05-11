class ApiConfig {
  static const String baseUrl = String.fromEnvironment(
    'TEKACHI_API_BASE_URL',
    defaultValue: 'https://tekachi-backend.onrender.com', //render ip
  );

  /// - Android emulator: `http://10.0.2.2:8080
}
