#!/bin/bash

# Flutter Story App - Enhanced Features Test Script
echo "🚀 Flutter Story App - Enhanced Features Test Script"
echo "=================================================="

# Test 1: Build and Analyze
echo "📋 Test 1: Code Analysis and Build Verification"
cd /Users/lraih/Projects/flutter/storyapp_dicoding

echo "  ⏳ Running flutter analyze..."
flutter analyze
if [ $? -eq 0 ]; then
    echo "  ✅ Code analysis passed - No issues found"
else
    echo "  ❌ Code analysis failed"
    exit 1
fi

# Test 2: Dependencies Check
echo "📦 Test 2: Dependencies Verification"
echo "  ⏳ Checking pub dependencies..."
flutter pub get
if [ $? -eq 0 ]; then
    echo "  ✅ Dependencies resolved successfully"
else
    echo "  ❌ Dependencies resolution failed"
    exit 1
fi

# Test 3: Code Generation
echo "🔧 Test 3: Code Generation Verification"
echo "  ⏳ Running build_runner for model generation..."
dart run build_runner build --delete-conflicting-outputs
if [ $? -eq 0 ]; then
    echo "  ✅ Code generation completed successfully"
else
    echo "  ❌ Code generation failed"
    exit 1
fi

# Test 4: Localization
echo "🌍 Test 4: Localization Generation"
echo "  ⏳ Generating localization files..."
flutter gen-l10n
if [ $? -eq 0 ]; then
    echo "  ✅ Localization files generated successfully"
else
    echo "  ❌ Localization generation failed"
    exit 1
fi

# Test 5: Build Variants
echo "🏗️ Test 5: Build Variants Verification"
echo "  ⏳ Testing Free version build..."
flutter build apk --debug -t lib/main_free.dart
if [ $? -eq 0 ]; then
    echo "  ✅ Free version builds successfully"
else
    echo "  ❌ Free version build failed"
    exit 1
fi

echo "  ⏳ Testing Paid version build..."
flutter build apk --debug -t lib/main_paid.dart
if [ $? -eq 0 ]; then
    echo "  ✅ Paid version builds successfully"
else
    echo "  ❌ Paid version build failed"
    exit 1
fi

echo ""
echo "🎉 ALL TESTS PASSED! 🎉"
echo "========================="
echo ""
echo "📱 Enhanced Features Implemented:"
echo "  ✅ Location permission handling with GPS detection"
echo "  ✅ Google Maps fallback system (no API key required)"
echo "  ✅ Infinite scrolling pagination"
echo "  ✅ JSON serializable models with code generation"
echo "  ✅ English & Indonesian localization"
echo "  ✅ Implicit, explicit, and custom painter animations"
echo "  ✅ Free vs Paid build variants"
echo "  ✅ Declarative navigation with GoRouter"
echo "  ✅ Enhanced location picker with GPS + manual input"
echo "  ✅ Clean code practices and responsive design"
echo ""
echo "🚀 Ready for manual testing on device!"
echo "💡 Use 'flutter run' for default version"
echo "💡 Use 'flutter run -t lib/main_paid.dart' for paid version"
echo ""
echo "🔍 Manual Testing Checklist:"
echo "  □ Location permission flow (GPS on/off scenarios)"
echo "  □ Story upload with location data (paid version)"
echo "  □ Infinite scroll pagination performance"
echo "  □ Free vs Paid version feature restrictions"
echo "  □ Animation smoothness and performance"
echo "  □ Localization switching"
echo "  □ Navigation flow and back button behavior"
