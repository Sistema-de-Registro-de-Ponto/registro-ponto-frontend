class AppConfig {
  final String apiBaseUrl;

  const AppConfig({required this.apiBaseUrl});

  factory AppConfig.fromEnvironment() {
    const baseUrl = String.fromEnvironment(
      'API_BASE_URL',
      defaultValue: 'http://localhost:8080',
    );
    return const AppConfig(apiBaseUrl: baseUrl);
  }
}
