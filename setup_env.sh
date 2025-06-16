#!/bin/bash

# Environment Setup Script for Flutter Story App
# This script helps set up the environment variables needed for the app

set -e

echo "🔧 Flutter Story App - Environment Setup"
echo "========================================"

# Check if .env file exists
if [ ! -f ".env" ]; then
    echo "📄 Creating .env file from template..."
    if [ -f ".env.example" ]; then
        cp .env.example .env
        echo "✅ .env file created from .env.example"
    else
        cat > .env << EOF
# Environment Variables for Flutter Story App

# Google Maps API Key
GOOGLE_MAPS_API_KEY=your_google_maps_api_key_here

# API Base URL (optional - defaults to Dicoding Story API)
# API_BASE_URL=https://story-api.dicoding.dev/v1
EOF
        echo "✅ .env file created with template"
    fi
else
    echo "📄 .env file already exists"
fi

# Check if Google Maps API key is set
if grep -q "your_google_maps_api_key_here" .env; then
    echo ""
    echo "⚠️  IMPORTANT: You need to set your Google Maps API key!"
    echo ""
    echo "1. Go to https://console.cloud.google.com/"
    echo "2. Create or select a project"
    echo "3. Enable Maps SDK for Android/iOS and Geocoding API"
    echo "4. Create an API key"
    echo "5. Edit .env file and replace 'your_google_maps_api_key_here' with your actual API key"
    echo ""
    echo "For detailed instructions, see: ENVIRONMENT_SETUP.md"
    echo ""
    
    read -p "Do you want to enter your API key now? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        read -p "Enter your Google Maps API key: " api_key
        if [ ! -z "$api_key" ]; then
            # Update .env file with the API key
            if [[ "$OSTYPE" == "darwin"* ]]; then
                # macOS
                sed -i '' "s/your_google_maps_api_key_here/$api_key/" .env
            else
                # Linux
                sed -i "s/your_google_maps_api_key_here/$api_key/" .env
            fi
            echo "✅ API key updated in .env file"
        fi
    fi
fi

# Check if Android local.properties needs updating
echo ""
echo "📱 Checking Android configuration..."

if [ ! -f "android/local.properties" ]; then
    echo "⚠️  android/local.properties not found. This will be created automatically."
else
    if ! grep -q "GOOGLE_MAPS_API_KEY" android/local.properties; then
        echo "📝 Adding Google Maps API key to android/local.properties..."
        echo "" >> android/local.properties
        echo "# Google Maps API Key (for development only - keep secure)" >> android/local.properties
        
        # Extract API key from .env if it exists
        if [ -f ".env" ]; then
            api_key=$(grep "GOOGLE_MAPS_API_KEY=" .env | cut -d '=' -f2)
            if [ ! -z "$api_key" ] && [ "$api_key" != "your_google_maps_api_key_here" ]; then
                echo "GOOGLE_MAPS_API_KEY=$api_key" >> android/local.properties
                echo "✅ API key added to android/local.properties"
            else
                echo "GOOGLE_MAPS_API_KEY=your_google_maps_api_key_here" >> android/local.properties
                echo "⚠️  Please update the API key in android/local.properties"
            fi
        fi
    else
        echo "✅ android/local.properties already configured"
    fi
fi

# Install dependencies
echo ""
echo "📦 Installing Flutter dependencies..."
flutter pub get

echo ""
echo "🎉 Setup complete!"
echo ""
echo "Next steps:"
echo "1. Make sure your Google Maps API key is correctly set in .env"
echo "2. Run 'flutter run' to start the app"
echo "3. For production builds, see ENVIRONMENT_SETUP.md for additional configuration"
echo ""
echo "If you encounter any issues, check ENVIRONMENT_SETUP.md for troubleshooting."
