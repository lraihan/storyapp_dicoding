import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:storyapp_dicoding/app/config/environment_config.dart';

void main() {
  group('Environment Configuration Tests', () {
    setUpAll(() async {
      // Load test environment variables
      await dotenv.load(fileName: ".env");
    });

    test('should load Google Maps API key from environment', () {
      final apiKey = EnvironmentConfig.googleMapsApiKey;
      expect(apiKey, isNotEmpty);
      expect(apiKey, isNot(''));
    });

    test('should indicate Google Maps is configured when API key is present', () {
      final isConfigured = EnvironmentConfig.isGoogleMapsConfigured;
      expect(isConfigured, isTrue);
    });

    test('should load API base URL with default fallback', () {
      final baseUrl = EnvironmentConfig.apiBaseUrl;
      expect(baseUrl, isNotEmpty);
      expect(baseUrl, contains('story-api.dicoding.dev'));
    });
  });
}
