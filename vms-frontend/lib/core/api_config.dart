class ApiConfig {
  ApiConfig._();

  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8080/api/v1',
  );

  static const Duration timeout = Duration(seconds: 15);
  static const int defaultPageSize = 10;
}
