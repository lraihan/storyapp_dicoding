# Environment Setup Guide

This guide explains how to set up environment variables for the Flutter Story App.

## Google Maps API Key Setup

### 1. Get your Google Maps API Key

1. Go to the [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select an existing one
3. Enable the following APIs:
   - Maps SDK for Android
   - Maps SDK for iOS
   - Geocoding API
   - Places API (optional)
4. Go to "APIs & Services" > "Credentials"
5. Click "Create Credentials" > "API Key"
6. Copy your API key

### 2. Configure the API Key

#### Option 1: Using .env file (Recommended)
1. Copy `.env.example` to `.env`:
   ```bash
   cp .env.example .env
   ```
2. Edit `.env` and replace `your_google_maps_api_key_here` with your actual API key:
   ```
   GOOGLE_MAPS_API_KEY=AIzaSyDMDsJ_8MGXvzAXK79Jdp6SxF8hZ2d7hlM
   ```

#### Option 2: Using Android local.properties
Add the following line to `android/local.properties`:
```
GOOGLE_MAPS_API_KEY=your_actual_api_key_here
```

### 3. Security Notes

- ✅ The `.env` file is automatically excluded from version control
- ✅ The `android/local.properties` file is also excluded from version control
- ✅ Your API key is loaded securely at runtime
- ❌ Never commit your actual API key to version control
- ❌ Never hardcode API keys in your source code

### 4. Build and Run

After setting up the environment variables:

```bash
flutter pub get
flutter run
```

## Environment Variables Reference

| Variable | Description | Default | Required |
|----------|-------------|---------|----------|
| `GOOGLE_MAPS_API_KEY` | Google Maps API key for map functionality | - | Yes |
| `API_BASE_URL` | Base URL for the Story API | `https://story-api.dicoding.dev/v1` | No |

## Troubleshooting

### Maps not loading
1. Verify your API key is correctly set in `.env`
2. Ensure you've enabled the required Google APIs
3. Check that your API key has no restrictions that would block your app
4. Run `flutter clean && flutter pub get` to refresh dependencies

### Build errors
1. Make sure you've run `flutter pub get` after adding the `.env` file
2. Verify the `.env` file is in the root directory of your project
3. Check that the `.env` file is properly formatted (no spaces around =)

## Production Deployment

For production builds, consider:
1. Using environment-specific .env files (.env.production, .env.staging)
2. Setting up CI/CD to inject environment variables
3. Using platform-specific secret management (Android Keystore, iOS Keychain)
