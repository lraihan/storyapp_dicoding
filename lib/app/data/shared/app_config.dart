enum AppFlavor {
  free,
  paid,
}
class AppConfig {
  static AppFlavor? _flavor;
  static void setFlavor(AppFlavor flavor) {
    _flavor = flavor;
  }
  static AppFlavor get flavor => _flavor ?? AppFlavor.free;
  static bool get isPaidVersion => flavor == AppFlavor.paid;
  static bool get isFreeVersion => flavor == AppFlavor.free;
  static String get appName {
    switch (flavor) {
      case AppFlavor.free:
        return 'Story App Free';
      case AppFlavor.paid:
        return 'Story App Pro';
    }
  }
  static String get packageName {
    switch (flavor) {
      case AppFlavor.free:
        return 'com.example.storyapp_dicoding.free';
      case AppFlavor.paid:
        return 'com.example.storyapp_dicoding.paid';
    }
  }
}
