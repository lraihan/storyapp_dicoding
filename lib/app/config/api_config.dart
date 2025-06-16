import '../config/environment_config.dart';

class ApiConfig {
  static String get baseUrl => EnvironmentConfig.apiBaseUrl;
  static bool get googleMapsEnabled => EnvironmentConfig.isGoogleMapsConfigured;
  static String get googleMapsApiKey => EnvironmentConfig.googleMapsApiKey;
  static const bool debugMode = true;
  static const int defaultPageSize = 10;
  static const int maxRetryAttempts = 3;
  static const double defaultZoomLevel = 15.0;
  static const int locationTimeoutSeconds = 30;
  static const int maxImageSize = 1024 * 1024;
  static const double imageQuality = 0.8;
}
