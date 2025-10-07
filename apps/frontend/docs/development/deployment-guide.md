# Deployment Guide

## 🚀 **Overview**

This guide explains how to build and deploy Flutter applications built with our framework. The guide covers web, mobile, and desktop deployment strategies.

## 🏗️ **Build Configuration**

### **Build Scripts**
```json
// package.json (if using npm scripts)
{
  "scripts": {
    "build:web": "flutter build web --release",
    "build:android": "flutter build apk --release",
    "build:ios": "flutter build ios --release",
    "build:windows": "flutter build windows --release",
    "build:macos": "flutter build macos --release",
    "build:linux": "flutter build linux --release",
    "build:all": "npm run build:web && npm run build:android && npm run build:windows",
    "deploy:web": "npm run build:web && firebase deploy",
    "deploy:android": "npm run build:android && fastlane android deploy"
  }
}
```

### **Flutter Build Configuration**
```yaml
# pubspec.yaml
name: generic_framework_app
description: A generic Flutter framework for any project
version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'
  flutter: ">=3.10.0"

flutter:
  uses-material-design: true
  generate: true
  
  # Assets
  assets:
    - assets/images/
    - assets/icons/
  
  # Fonts
  fonts:
    - family: CustomFont
      fonts:
        - asset: assets/fonts/CustomFont-Regular.ttf
        - asset: assets/fonts/CustomFont-Bold.ttf
          weight: 700
```

## 🌐 **Web Deployment**

### **Web Build Configuration**
```dart
// web/index.html
<!DOCTYPE html>
<html>
<head>
  <base href="$FLUTTER_BASE_HREF">
  <meta charset="UTF-8">
  <meta content="IE=Edge" http-equiv="X-UA-Compatible">
  <meta name="description" content="Generic Framework App">
  <meta name="apple-mobile-web-app-capable" content="yes">
  <meta name="apple-mobile-web-app-status-bar-style" content="black">
  <meta name="apple-mobile-web-app-title" content="Generic Framework App">
  <link rel="apple-touch-icon" href="icons/Icon-192.png">
  <link rel="icon" type="image/png" href="favicon.png"/>
  <link rel="manifest" href="manifest.json">
  <title>Generic Framework App</title>
  <link rel="stylesheet" type="text/css" href="styles.css">
</head>
<body>
  <script src="flutter.js" defer></script>
  <script>
    window.addEventListener('load', function(ev) {
      _flutter.loader.loadEntrypoint({
        serviceWorker: {
          serviceWorkerVersion: null,
        },
        onEntrypointLoaded: function(engineInitializer) {
          engineInitializer.initializeEngine().then(function(appRunner) {
            appRunner.runApp();
          });
        }
      });
    });
  </script>
</body>
</html>
```

### **Web Build Commands**
```bash
# Build for web
flutter build web --release

# Build with specific base href
flutter build web --release --base-href="/app/"

# Build with custom web renderer
flutter build web --release --web-renderer html

# Build with PWA support
flutter build web --release --pwa
```

### **Firebase Hosting Deployment**
```yaml
# firebase.json
{
  "hosting": {
    "public": "build/web",
    "ignore": [
      "firebase.json",
      "**/.*",
      "**/node_modules/**"
    ],
    "rewrites": [
      {
        "source": "**",
        "destination": "/index.html"
      }
    ],
    "headers": [
      {
        "source": "**/*.@(js|css)",
        "headers": [
          {
            "key": "Cache-Control",
            "value": "max-age=31536000"
          }
        ]
      }
    ]
  }
}
```

### **GitHub Pages Deployment**
```yaml
# .github/workflows/deploy-web.yml
name: Deploy Web App

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Setup Flutter
      uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.10.0'
        channel: 'stable'
    
    - name: Install dependencies
      run: flutter pub get
    
    - name: Build web app
      run: flutter build web --release
    
    - name: Deploy to GitHub Pages
      uses: peaceiris/actions-gh-pages@v3
      with:
        github_token: ${{ secrets.GITHUB_TOKEN }}
        publish_dir: ./build/web
```

## 📱 **Mobile Deployment**

### **Android Build Configuration**
```gradle
// android/app/build.gradle
android {
    compileSdkVersion 34
    
    defaultConfig {
        applicationId "com.example.generic_framework_app"
        minSdkVersion 21
        targetSdkVersion 34
        versionCode 1
        versionName "1.0.0"
    }
    
    buildTypes {
        release {
            signingConfig signingConfigs.release
            minifyEnabled true
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
    }
    
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }
}
```

### **iOS Build Configuration**
```xml
<!-- ios/Runner/Info.plist -->
<dict>
    <key>CFBundleDisplayName</key>
    <string>Generic Framework App</string>
    <key>CFBundleIdentifier</key>
    <string>com.example.generic_framework_app</string>
    <key>CFBundleVersion</key>
    <string>1.0.0</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0.0</string>
    <key>LSRequiresIPhoneOS</key>
    <true/>
    <key>UILaunchStoryboardName</key>
    <string>LaunchScreen</string>
    <key>UIMainStoryboardFile</key>
    <string>Main</string>
    <key>UISupportedInterfaceOrientations</key>
    <array>
        <string>UIInterfaceOrientationPortrait</string>
        <string>UIInterfaceOrientationLandscapeLeft</string>
        <string>UIInterfaceOrientationLandscapeRight</string>
    </array>
</dict>
```

### **Mobile Build Commands**
```bash
# Build Android APK
flutter build apk --release

# Build Android App Bundle
flutter build appbundle --release

# Build iOS
flutter build ios --release

# Build for specific architecture
flutter build apk --release --target-platform android-arm64
```

### **Fastlane Configuration**
```ruby
# fastlane/Fastfile
default_platform(:android)

platform :android do
  desc "Deploy Android app to Play Store"
  lane :deploy do
    gradle(
      task: "bundle",
      build_type: "Release"
    )
    
    upload_to_play_store(
      track: "internal",
      aab: "app/build/outputs/bundle/release/app-release.aab"
    )
  end
end

platform :ios do
  desc "Deploy iOS app to App Store"
  lane :deploy do
    build_app(
      scheme: "Runner",
      export_method: "app-store"
    )
    
    upload_to_app_store(
      ipa: "Runner.ipa"
    )
  end
end
```

## 🖥️ **Desktop Deployment**

### **Windows Build Configuration**
```cmake
# windows/CMakeLists.txt
cmake_minimum_required(VERSION 3.14)
project(runner LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Flutter configuration
set(FLUTTER_MANAGED_DIR "${CMAKE_CURRENT_SOURCE_DIR}/flutter")
set(FLUTTER_OUTPUT_DIR "${CMAKE_CURRENT_SOURCE_DIR}/build/windows/x64/runner/Release")

# Include Flutter
include("${FLUTTER_MANAGED_DIR}/generated_config.cmake")
include("${FLUTTER_MANAGED_DIR}/generated_plugins.cmake")

# Create executable
add_executable(${BINARY_NAME} WIN32
  "flutter_window.cpp"
  "main.cpp"
  "runner.exe.manifest"
  "utils.cpp"
  "win32_window.cpp"
  "resources/runner.rc"
  "Runner.rc"
)

# Link libraries
target_link_libraries(${BINARY_NAME} PRIVATE flutter flutter_wrapper_app)
target_link_libraries(${BINARY_NAME} PRIVATE "dwmapi.lib")
target_link_libraries(${BINARY_NAME} PRIVATE "d3d11.lib")
target_link_libraries(${BINARY_NAME} PRIVATE "dxgi.lib")
```

### **macOS Build Configuration**
```swift
// macos/Runner/AppDelegate.swift
import Cocoa
import FlutterMacOS

@NSApplicationMain
class AppDelegate: FlutterAppDelegate {
  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return true
  }
}
```

### **Desktop Build Commands**
```bash
# Build Windows
flutter build windows --release

# Build macOS
flutter build macos --release

# Build Linux
flutter build linux --release

# Build with specific architecture
flutter build windows --release --target-platform windows-x64
```

## 🐳 **Docker Deployment**

### **Dockerfile for Web**
```dockerfile
# Dockerfile.web
FROM node:18-alpine AS build

WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production

FROM nginx:alpine
COPY --from=build /app /usr/share/nginx/html
COPY nginx.conf /etc/nginx/nginx.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

### **Dockerfile for Flutter**
```dockerfile
# Dockerfile.flutter
FROM ubuntu:20.04

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    xz-utils \
    zip \
    libglu1-mesa \
    && rm -rf /var/lib/apt/lists/*

# Install Flutter
RUN git clone https://github.com/flutter/flutter.git /flutter
ENV PATH="/flutter/bin:${PATH}"

# Set working directory
WORKDIR /app

# Copy pubspec files
COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get

# Copy source code
COPY . .

# Build the app
RUN flutter build web --release

# Expose port
EXPOSE 8080

# Start the app
CMD ["flutter", "run", "-d", "web-server", "--web-port", "8080", "--web-hostname", "0.0.0.0"]
```

### **Docker Compose**
```yaml
# docker-compose.yml
version: '3.8'

services:
  web:
    build:
      context: .
      dockerfile: Dockerfile.web
    ports:
      - "80:80"
    environment:
      - NODE_ENV=production
    
  api:
    build:
      context: ../backend
      dockerfile: Dockerfile
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=production
```

## 🔧 **CI/CD Pipeline**

### **GitHub Actions Workflow**
```yaml
# .github/workflows/ci-cd.yml
name: CI/CD Pipeline

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3
    
    - name: Setup Flutter
      uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.10.0'
        channel: 'stable'
    
    - name: Install dependencies
      run: flutter pub get
    
    - name: Run tests
      run: flutter test
    
    - name: Run analysis
      run: flutter analyze
    
    - name: Build web
      run: flutter build web --release
    
    - name: Build Android
      run: flutter build apk --release
    
    - name: Build Windows
      run: flutter build windows --release

  deploy:
    needs: test
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    steps:
    - uses: actions/checkout@v3
    
    - name: Setup Flutter
      uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.10.0'
        channel: 'stable'
    
    - name: Build and deploy
      run: |
        flutter build web --release
        # Deploy to your hosting service
```

## 📚 **Best Practices**

1. **Use release builds** for production deployment
2. **Configure proper signing** for mobile apps
3. **Set up CI/CD pipelines** for automated deployment
4. **Use environment variables** for configuration
5. **Implement proper error handling** in production
6. **Monitor performance** and crashes
7. **Use CDN** for web assets
8. **Implement proper caching** strategies
9. **Test on multiple devices** and platforms
10. **Keep dependencies updated** regularly

## 🔍 **Troubleshooting**

### **Common Build Issues**
```bash
# Clean build
flutter clean
flutter pub get
flutter build web --release

# Check Flutter doctor
flutter doctor -v

# Check dependencies
flutter pub deps

# Analyze code
flutter analyze
```

### **Build Optimization**
```bash
# Build with specific optimizations
flutter build web --release --dart-define=FLUTTER_WEB_USE_SKIA=true

# Build with tree shaking
flutter build web --release --tree-shake-icons

# Build with specific target
flutter build web --release --target-platform web-javascript
```

This deployment guide provides comprehensive strategies for deploying Flutter applications across all platforms.
