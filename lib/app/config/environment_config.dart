import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvironmentConfig {
  static String get googleMapsApiKey {
    return dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';
  }

  static String get apiBaseUrl {
    return dotenv.env['API_BASE_URL'] ?? 'https://story-api.dicoding.dev/v1';
  }

  static bool get isGoogleMapsConfigured {
    return googleMapsApiKey.isNotEmpty;
  }
}
