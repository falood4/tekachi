class ApiConfig {
  static const String baseUrl = String.fromEnvironment(
    'TEKACHI_API_BASE_URL',
    defaultValue: 'https://tekachi-ztuz.onrender.com', //render ip
  );
}
