# Story App - Enhanced Flutter Application

A comprehensive Flutter application for sharing stories with location features, infinite scrolling, animations, and build variants.

## ✨ Features

### Core Features
- **User Authentication** - Login/Register with JWT token management
- **Story Upload** - Take photos and share stories with descriptions
- **Story Feed** - Browse stories from all users with infinite scroll pagination
- **Story Details** - View full story details with author information

### Enhanced Features
- **🗺️ Location Support** - Add GPS location to stories and view on interactive maps
- **📱 Infinite Scrolling** - Smooth pagination with loading states and error handling
- **🎨 Animations** - Implicit, explicit, and custom painter animations
- **🌍 Localization** - English and Indonesian language support
- **🏗️ Build Variants** - Free and Paid versions with feature restrictions
- **🎯 Code Generation** - JSON serialization with build_runner
- **📱 Responsive Design** - Clean UI following Material Design 3

### Advanced Features
- **Shimmer Loading** - Beautiful loading animations
- **Error Handling** - Comprehensive error states with retry options
- **Offline Support** - Local storage with GetStorage
- **Permission Management** - Camera and location permissions
- **Image Caching** - Optimized image loading with CachedNetworkImage

## 🏗️ Build Variants

### Free Version
- Basic story sharing
- View stories from other users
- Authentication features
- ❌ Cannot add location to stories

### Paid Version
- All Free features
- ✅ Location picker for stories
- ✅ Interactive maps showing story locations
- ✅ GPS coordinates and address lookup

## 🛠️ Technology Stack

### Core Framework
- **Flutter 3.27+** - Cross-platform development
- **Dart 3.6+** - Programming language

### State Management & Navigation
- **GetX** - State management, dependency injection, and routing
- **GoRouter** - Declarative routing

### Networking & Data
- **Dio** - HTTP client for API calls
- **JSON Serializable** - Automatic JSON serialization
- **Build Runner** - Code generation

### UI & Animations
- **Material Design 3** - Modern design system
- **Custom Painters** - Wave and circle progress animations
- **Shimmer** - Loading animations
- **CachedNetworkImage** - Optimized image loading

### Maps & Location
- **Google Maps Flutter** - Interactive maps
- **Geolocator** - GPS location services
- **Geocoding** - Address ↔ Coordinates conversion

### Storage & Localization
- **GetStorage** - Local data persistence
- **Flutter Localizations** - Multi-language support
- **SharedPreferences** - Simple key-value storage

### Utilities
- **Image Picker** - Camera and gallery access
- **Permission Handler** - Runtime permissions
- **Infinite Scroll Pagination** - Efficient list pagination

## 📱 Setup Instructions

### Prerequisites
1. **Flutter SDK** 3.27 or higher
2. **Dart SDK** 3.6 or higher
3. **Android Studio** or **VS Code** with Flutter extensions
4. **Google Maps API Key** (for map features)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd storyapp_dicoding
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate code files**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **Configure Google Maps API**
   - Get an API key from [Google Cloud Console](https://console.cloud.google.com/)
   - Enable Maps SDK for Android/iOS
   - Update `android/app/src/main/AndroidManifest.xml`:
     ```xml
     <meta-data
       android:name="com.google.android.geo.API_KEY"
       android:value="YOUR_ACTUAL_API_KEY_HERE" />
     ```

5. **Run the application**
   ```bash
   # Default (Paid) version
   flutter run
   
   # Free version
   flutter run --flavor free -t lib/main_free.dart
   
   # Paid version
   flutter run --flavor paid -t lib/main_paid.dart
   ```

### Building for Release

```bash
# Build Free version APK
flutter build apk --flavor free -t lib/main_free.dart

# Build Paid version APK
flutter build apk --flavor paid -t lib/main_paid.dart
```

## 🏗️ Project Structure

```
lib/
├── main.dart                    # Main entry point (Paid version)
├── main_free.dart              # Free version entry point
├── main_paid.dart              # Paid version entry point
├── app/
│   ├── data/
│   │   ├── models/             # Data models with JSON serialization
│   │   │   ├── story.dart      # Story, StoryResponse, ApiResponse
│   │   │   └── user.dart       # User, LoginRequest, RegisterRequest
│   │   ├── service/            # API and business logic services
│   │   │   ├── api_service.dart       # HTTP API client
│   │   │   ├── location_service.dart  # GPS and geocoding
│   │   │   └── preferences_service.dart # Local storage
│   │   └── shared/
│   │       └── app_config.dart # Build variant configuration
│   ├── modules/                # Feature modules (MVC pattern)
│   │   ├── auth/              # Authentication (Login/Register)
│   │   ├── home/              # Story feed with infinite scroll
│   │   ├── add_story/         # Story creation with location
│   │   └── story_detail/      # Story details with map
│   ├── routes/
│   │   └── app_pages.dart     # GoRouter configuration
│   └── widgets/               # Reusable UI components
│       ├── animations.dart    # Animation widgets
│       ├── custom_painters.dart # Custom drawing widgets
│       ├── location_picker_widget.dart # Location selection UI
│       └── story_map_widget.dart # Story location display
├── l10n/                      # Localization files
│   ├── app_en.arb            # English translations
│   ├── app_id.arb            # Indonesian translations
│   └── app_localizations.dart # Generated localization class
```

## 🎨 Key Features Implementation

### 1. Infinite Scroll Pagination
Uses `PagingController` from `infinite_scroll_pagination` package for efficient data loading:
- Automatic loading indicators
- Error handling with retry functionality
- Smooth scrolling performance
- Memory efficient list management

### 2. Location Features
Comprehensive location support with:
- **GPS Access** - Get current user location
- **Interactive Maps** - Google Maps integration with markers
- **Geocoding** - Convert coordinates to human-readable addresses
- **Location Picker** - Custom widget for selecting story locations

### 3. Code Generation
Utilizes `json_serializable` for type-safe JSON handling:
- Automatic `fromJson()` and `toJson()` methods
- Build-time code generation
- Reduced boilerplate code
- Better performance than reflection

### 4. Build Variants
Flavor-based architecture for Free/Paid versions:
- Shared codebase with feature flags
- Different app names and package IDs
- Conditional feature access
- Easy deployment management

### 5. Animation System
Multiple animation types for engaging UX:
- **Implicit Animations** - Smooth property transitions
- **Explicit Animations** - Custom animation controllers
- **Custom Painters** - Wave effects and progress indicators
- **Loading States** - Shimmer effects during data loading

## 🌍 Localization

The app supports English and Indonesian languages with comprehensive translations:

### Adding New Languages
1. Create new ARB file: `l10n/app_[locale].arb`
2. Add translations following existing key structure
3. Update `supportedLocales` in main app files
4. Run `flutter gen-l10n` to generate classes

### Key Translation Categories
- Authentication flows
- Story management
- Location features
- Error messages
- UI labels and buttons

## 🚀 API Integration

### Base Configuration
- **Base URL**: Configurable API endpoint
- **Authentication**: JWT token-based
- **Error Handling**: Comprehensive error responses
- **Request/Response Models**: Type-safe with code generation

### Key Endpoints
- `POST /register` - User registration
- `POST /login` - User authentication
- `GET /stories` - Paginated story list
- `POST /stories` - Create new story with optional location
- `GET /stories/{id}` - Get story details

## 🧪 Testing

### Running Tests
```bash
# Unit tests
flutter test

# Integration tests
flutter test integration_test/

# Analyze code quality
flutter analyze
```

### Test Coverage
- Model serialization/deserialization
- Service layer functionality
- Widget testing for UI components
- Integration tests for complete flows

## 📱 Platform Support

### Android
- Minimum SDK: 21 (Android 5.0)
- Target SDK: 34 (Android 14)
- Permissions: Camera, Location, Internet, Storage

### iOS
- Minimum version: iOS 12.0
- Required permissions: Camera, Location
- App Transport Security configured

## 🔧 Development Tools

### Recommended Extensions (VS Code)
- Flutter
- Dart
- Flutter Intl
- Bracket Pair Colorizer
- Error Lens

### Code Generation Commands
```bash
# Build models
dart run build_runner build

# Watch for changes
dart run build_runner watch

# Clean and rebuild
dart run build_runner build --delete-conflicting-outputs
```

## 📝 License

This project is part of the Dicoding Flutter learning path and is intended for educational purposes.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## 📞 Support

For questions or issues, please create an issue in the repository or contact the development team.

---

**Made with ❤️ using Flutter**
