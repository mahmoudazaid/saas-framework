# Flutter Development Setup Guide

> **🛠️ Complete Development Environment Setup for Flutter Framework**

This guide provides step-by-step instructions for setting up the Flutter development environment for the generic framework.

## 📋 **Table of Contents**

1. [Prerequisites](#prerequisites)
2. [Flutter Installation](#flutter-installation)
3. [IDE Setup](#ide-setup)
4. [Project Setup](#project-setup)
5. [Dependencies Installation](#dependencies-installation)
6. [Configuration](#configuration)
7. [Running the App](#running-the-app)
8. [Testing Setup](#testing-setup)
9. [Troubleshooting](#troubleshooting)

## 🔧 **Prerequisites**

### **System Requirements**
- **Operating System**: macOS, Windows, or Linux
- **RAM**: 8GB minimum, 16GB recommended
- **Storage**: 10GB free space minimum
- **Network**: Internet connection for package downloads

### **Required Software**
- **Flutter SDK**: 3.0.0 or higher
- **Dart SDK**: 3.0.0 or higher (included with Flutter)
- **Git**: For version control
- **IDE**: Android Studio, VS Code, or IntelliJ IDEA

### **Platform-Specific Requirements**

#### **macOS (for iOS development)**
- **Xcode**: 14.0 or higher
- **CocoaPods**: For iOS dependencies
- **iOS Simulator**: Included with Xcode

#### **Windows (for Android development)**
- **Android Studio**: Latest version
- **Android SDK**: API level 21 or higher
- **Android Emulator**: For testing

#### **Linux (for Android development)**
- **Android Studio**: Latest version
- **Android SDK**: API level 21 or higher
- **Android Emulator**: For testing

## 📱 **Flutter Installation**

### **1. Download Flutter SDK**

#### **macOS**
```bash
# Download Flutter SDK
cd ~/development
curl -O https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos_3.16.0-stable.zip

# Extract Flutter SDK
unzip flutter_macos_3.16.0-stable.zip
```

#### **Windows**
1. Download Flutter SDK from [Flutter website](https://flutter.dev/docs/get-started/install/windows)
2. Extract to `C:\flutter`

#### **Linux**
```bash
# Download Flutter SDK
cd ~/development
wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.16.0-stable.tar.xz

# Extract Flutter SDK
tar xf flutter_linux_3.16.0-stable.tar.xz
```

### **2. Add Flutter to PATH**

#### **macOS/Linux**
```bash
# Add to ~/.bashrc or ~/.zshrc
export PATH="$PATH:$HOME/development/flutter/bin"

# Reload shell configuration
source ~/.bashrc  # or source ~/.zshrc
```

#### **Windows**
1. Add `C:\flutter\bin` to your system PATH
2. Restart your command prompt

### **3. Verify Installation**
```bash
# Check Flutter installation
flutter --version

# Run Flutter doctor
flutter doctor
```

## 💻 **IDE Setup**

### **VS Code (Recommended)**

#### **1. Install VS Code**
- Download from [VS Code website](https://code.visualstudio.com/)
- Install the Flutter extension
- Install the Dart extension

#### **2. Configure VS Code**
```json
// settings.json
{
  "dart.flutterSdkPath": "/path/to/flutter",
  "dart.sdkPath": "/path/to/flutter/bin/cache/dart-sdk",
  "editor.formatOnSave": true,
  "editor.codeActionsOnSave": {
    "source.fixAll": true
  },
  "dart.lineLength": 80,
  "dart.insertArgumentPlaceholders": false,
  "dart.previewFlutterUiGuides": true,
  "dart.previewFlutterUiGuidesCustomTracking": true
}
```

#### **3. Install Extensions**
- **Flutter**: Official Flutter extension
- **Dart**: Official Dart extension
- **Flutter Intl**: For internationalization
- **Bracket Pair Colorizer**: For better code readability
- **GitLens**: For Git integration

### **Android Studio**

#### **1. Install Android Studio**
- Download from [Android Studio website](https://developer.android.com/studio)
- Install Flutter and Dart plugins

#### **2. Configure Android Studio**
- Set Flutter SDK path in preferences
- Configure Android SDK path
- Set up Android emulator

### **IntelliJ IDEA**

#### **1. Install IntelliJ IDEA**
- Download from [JetBrains website](https://www.jetbrains.com/idea/)
- Install Flutter and Dart plugins

## 🚀 **Project Setup**

### **1. Clone Repository**
```bash
# Clone the repository
git clone <repository-url>
cd gym-manager

# Navigate to Flutter app
cd apps/frontend
```

### **2. Verify Flutter Project**
```bash
# Check Flutter project structure
flutter doctor

# Verify project configuration
flutter analyze
```

### **3. Check Flutter Version**
```bash
# Ensure compatible Flutter version
flutter --version
# Should be 3.0.0 or higher
```

## 📦 **Dependencies Installation**

### **1. Install Flutter Dependencies**
```bash
# Install dependencies
flutter pub get

# Upgrade dependencies (if needed)
flutter pub upgrade
```

### **2. Generate Localization Files**
```bash
# Generate localization files
flutter gen-l10n
```

### **3. Generate Code (if using code generation)**
```bash
# Generate code (if using build_runner)
flutter packages pub run build_runner build

# Watch for changes (development)
flutter packages pub run build_runner watch
```

### **4. Verify Dependencies**
```bash
# Check for dependency issues
flutter pub deps

# Verify no conflicts
flutter pub outdated
```

## ⚙️ **Configuration**

### **1. Environment Configuration**

#### **Create Environment Files**
```bash
# Create environment files
touch .env
touch .env.local
touch .env.production
```

#### **Environment Variables**
```bash
# .env
API_BASE_URL=https://api.example.com
API_TIMEOUT=30000
CACHE_DURATION=3600
DEBUG_MODE=true
```

### **2. Flutter Configuration**

#### **pubspec.yaml**
```yaml
name: generic_framework_app
description: Generic Flutter framework for multi-platform applications
version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'
  flutter: ">=3.0.0"

dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter
  # ... other dependencies
```

#### **analysis_options.yaml**
```yaml
include: package:flutter_lints/flutter.yaml

linter:
  rules:
    - prefer_const_constructors
    - prefer_const_literals_to_create_immutables
    - avoid_unnecessary_containers
    - avoid_print
    - prefer_single_quotes
    - sort_constructors_first
    - sort_unnamed_constructors_first
    - directives_ordering
    - file_names
    - library_names
    - non_constant_identifier_names
    - constant_identifier_names
    - camel_case_types
    - camel_case_extensions
    - library_prefixes
    - avoid_web_libraries_in_flutter
    - avoid_relative_imports
    - avoid_renaming_method_parameters
    - avoid_returning_null_for_future
    - avoid_slow_async_io
    - avoid_type_to_string
    - cancel_subscriptions
    - close_sinks
    - comment_references
    - control_flow_in_finally
    - empty_statements
    - hash_and_equals
    - invariant_booleans
    - iterable_contains_unrelated_type
    - list_remove_unrelated_type
    - literal_only_boolean_expressions
    - no_adjacent_strings_in_list
    - no_duplicate_case_values
    - no_logic_in_create_state
    - prefer_adjacent_string_concatenation
    - prefer_collection_literals
    - prefer_conditional_assignment
    - prefer_contains
    - prefer_equal_for_default_values
    - prefer_final_fields
    - prefer_final_in_for_each
    - prefer_final_locals
    - prefer_for_elements_to_map_fromIterable
    - prefer_function_declarations_over_variables
    - prefer_if_null_operators
    - prefer_initializing_formals
    - prefer_inlined_adds
    - prefer_interpolation_to_compose_strings
    - prefer_is_empty
    - prefer_is_not_empty
    - prefer_iterable_whereType
    - prefer_null_aware_operators
    - prefer_relative_imports
    - prefer_single_quotes
    - prefer_spread_collections
    - prefer_typing_uninitialized_variables
    - provide_deprecation_message
    - recursive_getters
    - slash_for_doc_comments
    - sort_child_properties_last
    - sort_constructors_first
    - sort_unnamed_constructors_first
    - type_annotate_public_apis
    - type_init_formals
    - unawaited_futures
    - unnecessary_await_in_return
    - unnecessary_brace_in_string_interps
    - unnecessary_const
    - unnecessary_constructor_name
    - unnecessary_getters_setters
    - unnecessary_lambdas
    - unnecessary_new
    - unnecessary_null_aware_assignments
    - unnecessary_null_checks
    - unnecessary_null_in_if_null_operators
    - unnecessary_nullable_for_final_variable_declarations
    - unnecessary_overrides
    - unnecessary_parenthesis
    - unnecessary_raw_strings
    - unnecessary_string_escapes
    - unnecessary_string_interpolations
    - unnecessary_this
    - unrelated_type_equality_checks
    - use_build_context_synchronously
    - use_decorated_box
    - use_full_hex_values_for_flutter_colors
    - use_function_type_syntax_for_parameters
    - use_if_null_to_convert_nulls_to_bools
    - use_is_even_rather_than_modulo
    - use_key_in_widget_constructors
    - use_late_for_private_fields_and_variables
    - use_named_constants
    - use_raw_strings
    - use_rethrow_when_possible
    - use_setters_to_change_properties
    - use_string_buffers
    - use_test_throws_matchers
    - use_to_and_as_if_applicable
    - valid_regexps
    - void_checks
```

### **3. Platform-Specific Configuration**

#### **iOS Configuration**
```bash
# Navigate to iOS directory
cd ios

# Install CocoaPods dependencies
pod install

# Return to Flutter directory
cd ..
```

#### **Android Configuration**
```bash
# Navigate to Android directory
cd android

# Check Gradle configuration
./gradlew --version

# Return to Flutter directory
cd ..
```

## 🏃 **Running the App**

### **1. Check Available Devices**
```bash
# List available devices
flutter devices

# List available emulators
flutter emulators
```

### **2. Start Emulator/Simulator**

#### **iOS Simulator (macOS only)**
```bash
# Start iOS Simulator
open -a Simulator

# Or use Flutter command
flutter emulators --launch apple_ios_simulator
```

#### **Android Emulator**
```bash
# List available emulators
flutter emulators

# Start specific emulator
flutter emulators --launch <emulator_id>
```

### **3. Run the App**
```bash
# Run on connected device/emulator
flutter run

# Run on specific device
flutter run -d <device_id>

# Run in debug mode
flutter run --debug

# Run in release mode
flutter run --release

# Run in profile mode
flutter run --profile
```

### **4. Hot Reload and Hot Restart**
- **Hot Reload**: Press `r` in terminal or `Ctrl+S` in VS Code
- **Hot Restart**: Press `R` in terminal or `Ctrl+Shift+S` in VS Code
- **Quit**: Press `q` in terminal or `Ctrl+C`

## 🧪 **Testing Setup**

### **1. Run Tests**
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/features/home/domain/entities/sample_entity_test.dart

# Run tests with specific tags
flutter test --tags unit
flutter test --tags smoke
flutter test --tags "feature,fast"

# Run tests excluding specific tags
flutter test --exclude-tags slow
flutter test --exclude-tags network

# Run tests with coverage
flutter test --coverage

# Run tests in verbose mode
flutter test --verbose
```

### **2. Test Configuration**
```yaml
# dart_test.yaml
name: generic_framework_app

tags:
  unit:
    description: "Unit tests (fast, isolated)"
  integration:
    description: "Integration tests (medium speed)"
  widget:
    description: "Widget tests (UI components)"
  # ... other tags

test_on: vm

coverage:
  path: coverage/
  exclude:
    - "**/*.g.dart"
    - "**/*.freezed.dart"
    - "**/*.mocks.dart"
    - "**/generated/**"
    - "**/test/**"
    - "**/integration_test/**"

platforms: [vm]
timeout: 30s
concurrency: 4
```

### **3. Test Coverage**
```bash
# Generate coverage report
flutter test --coverage

# View coverage report (if lcov is installed)
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

## 🔧 **Build Configuration**

### **1. Debug Build**
```bash
# Build debug APK (Android)
flutter build apk --debug

# Build debug IPA (iOS)
flutter build ios --debug
```

### **2. Release Build**
```bash
# Build release APK (Android)
flutter build apk --release

# Build release IPA (iOS)
flutter build ios --release

# Build release web
flutter build web --release
```

### **3. Build for Specific Platforms**
```bash
# Build for Android
flutter build apk

# Build for iOS
flutter build ios

# Build for Web
flutter build web

# Build for Windows
flutter build windows

# Build for macOS
flutter build macos

# Build for Linux
flutter build linux
```

## 🐛 **Troubleshooting**

### **Common Issues**

#### **1. Flutter Doctor Issues**
```bash
# Run Flutter doctor
flutter doctor

# Run Flutter doctor with verbose output
flutter doctor -v

# Fix specific issues
flutter doctor --android-licenses
```

#### **2. Dependency Issues**
```bash
# Clean Flutter cache
flutter clean

# Get dependencies again
flutter pub get

# Clear pub cache
flutter pub cache clean

# Reinstall dependencies
flutter pub deps
```

#### **3. Build Issues**
```bash
# Clean build cache
flutter clean

# Rebuild
flutter pub get
flutter run
```

#### **4. iOS Issues**
```bash
# Clean iOS build
cd ios
rm -rf Pods
rm Podfile.lock
pod install
cd ..

# Rebuild
flutter clean
flutter pub get
flutter run
```

#### **5. Android Issues**
```bash
# Clean Android build
cd android
./gradlew clean
cd ..

# Rebuild
flutter clean
flutter pub get
flutter run
```

### **Performance Issues**

#### **1. Slow Build Times**
- Use `--debug` for development
- Use `--profile` for performance testing
- Use `--release` for production

#### **2. Memory Issues**
- Close unused emulators
- Restart IDE
- Clear Flutter cache

#### **3. Network Issues**
- Check internet connection
- Use VPN if needed
- Clear pub cache

## 📚 **Additional Resources**

### **Flutter Documentation**
- [Flutter Official Docs](https://flutter.dev/docs)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Flutter Widget Catalog](https://flutter.dev/docs/development/ui/widgets)

### **Framework Documentation**
- [Frontend Documentation Overview](../frontend-documentation-overview.md)
- [Clean Architecture Guide](../architecture/clean-architecture.md)
- [State Management Guide](../architecture/state-management.md)

### **Community Resources**
- [Flutter Community](https://flutter.dev/community)
- [Flutter Samples](https://flutter.dev/docs/cookbook)
- [Flutter Packages](https://pub.dev/)

## ✅ **Verification Checklist**

Before starting development, verify:

- [ ] Flutter SDK installed and in PATH
- [ ] Flutter doctor shows no critical issues
- [ ] IDE configured with Flutter extensions
- [ ] Project dependencies installed
- [ ] Localization files generated
- [ ] Tests running successfully
- [ ] App runs on target platform(s)
- [ ] Hot reload working
- [ ] Build process working

## 🎯 **Next Steps**

After completing setup:

1. **Read Architecture Guide**: [Clean Architecture](../architecture/clean-architecture.md)
2. **Learn State Management**: [State Management](../architecture/state-management.md)
3. **Explore UI Components**: [Widget Library](../ui/widget-library.md)
4. **Write Tests**: [Testing Guide](../testing/testing-guide.md)
5. **Start Development**: Begin building features

---

**Last Updated**: September 2024  
**Flutter Version**: 3.0+  
**Dart Version**: 3.0+
