# Loading Widgets Documentation

## 🎯 **Overview**

The loading widgets provide smooth transitions between screens with dimming background and loading progress indicators. All widgets support localization and are designed to be reusable across the application.

## 🏗️ **Architecture**

### **Core Widgets**
- `LoadingOverlay` - Basic loading overlay with customizable appearance
- `LoadingOverlayWrapper` - Wraps content with loading overlay
- `LoadingScreen` - Full-screen loading state

### **Reusable Helpers**
- `LoadingScenarios` - Pre-configured loading overlays for common use cases
- `LoadingMessages` - Localized loading messages helper
- `LoadingStateManager` - Widget for managing loading states
- `AsyncOperationHandler` - Widget for handling async operations with loading

## 🚀 **Usage**

### **Basic Loading Overlay**

```dart
import 'package:generic_framework_app/ui/widgets/widgets.dart';

// Simple loading overlay
LoadingOverlay(
  isLoading: _isLoading,
  child: MyContentWidget(),
)

// With custom message
LoadingOverlay(
  isLoading: _isLoading,
  message: "Processing your request...",
  child: MyContentWidget(),
)
```

### **Loading Overlay Wrapper**

```dart
// Wrap any widget with loading overlay
LoadingOverlayWrapper(
  isLoading: _isLoading,
  child: MyContentWidget(),
)
```

### **Full Screen Loading**

```dart
// Full screen loading state
LoadingScreen(
  message: "Initializing application...",
  showProgress: true,
  progress: 0.7,
)
```

### **Reusable Loading Scenarios**

```dart
// Data loading
LoadingScenarios.dataLoading(
  isLoading: _isLoading,
  child: MyContentWidget(),
)

// Navigation loading
LoadingScenarios.navigationLoading(
  isLoading: _isNavigating,
  message: "Switching screens...",
  child: MyScreen(),
)

// Form submission loading
LoadingScenarios.formSubmissionLoading(
  isLoading: _isSubmitting,
  child: MyFormWidget(),
)

// Progress loading
LoadingScenarios.progressLoading(
  isLoading: _isProcessing,
  progress: _progress,
  child: MyContentWidget(),
)
```

### **Loading State Management**

```dart
// Automatic loading state management
LoadingStateManager(
  onLoad: () async {
    await loadData();
  },
  loadingType: LoadingType.data,
  child: MyContentWidget(),
)

// Async operation handler
AsyncOperationHandler(
  operation: () async {
    await submitForm();
  },
  loadingType: LoadingType.processing,
  child: ElevatedButton(
    onPressed: () {}, // Will be handled by AsyncOperationHandler
    child: Text('Submit'),
  ),
)
```

### **Localized Loading Messages**

```dart
// Get localized loading message
final message = LoadingMessages.getLoadingMessage(
  context, 
  LoadingType.data
);

// Available loading types:
// - LoadingType.data
// - LoadingType.navigation  
// - LoadingType.processing
// - LoadingType.general
// - LoadingType.wait
```

## 🎨 **Customization**

### **Visual Customization**

```dart
LoadingOverlay(
  isLoading: _isLoading,
  backgroundColor: Colors.blue,
  opacity: 0.8,
  indicatorColor: Colors.white,
  indicatorSize: 50.0,
  child: MyContentWidget(),
)
```

### **Animation Customization**

```dart
LoadingOverlay(
  isLoading: _isLoading,
  animationDuration: Duration(milliseconds: 500),
  animationCurve: Curves.easeInOut,
  child: MyContentWidget(),
)
```

### **Progress Indicators**

```dart
// Circular progress with value
LoadingOverlay(
  isLoading: _isLoading,
  showProgress: true,
  progress: 0.7,
  child: MyContentWidget(),
)

// Linear progress bar
LoadingOverlay(
  isLoading: _isLoading,
  showProgress: true,
  progress: 0.5,
  child: MyContentWidget(),
)
```

## 🌍 **Localization**

The loading widgets automatically use localized text from the ARB files:

```json
// app_en.arb
{
  "loading": "Loading...",
  "loadingData": "Loading your data...",
  "navigating": "Navigating...",
  "processing": "Processing...",
  "pleaseWait": "Please wait..."
}
```

## 🧪 **Testing**

The loading widgets can be tested as part of feature tests or integration tests when used in actual screens and workflows.

## 📚 **Best Practices**

1. **Use appropriate loading scenarios** for different contexts
2. **Provide meaningful loading messages** to users
3. **Use progress indicators** for long-running operations
4. **Handle loading states** properly in your state management
5. **Test loading states** as part of feature tests
6. **Use consistent loading patterns** across the app

## 🔧 **Usage Examples**

The loading widgets can be used in various scenarios throughout your application. See the code examples above for different implementation patterns.

## 🎯 **Common Use Cases**

### **Screen Transitions**
```dart
// Show loading during navigation
LoadingScenarios.navigationLoading(
  isLoading: _isNavigating,
  child: MyScreen(),
)
```

### **Data Fetching**
```dart
// Show loading while fetching data
LoadingScenarios.dataLoading(
  isLoading: _isLoadingData,
  child: DataDisplayWidget(),
)
```

### **Form Submissions**
```dart
// Show loading during form submission
LoadingScenarios.formSubmissionLoading(
  isLoading: _isSubmitting,
  child: MyFormWidget(),
)
```

### **File Uploads**
```dart
// Show progress during file upload
LoadingScenarios.progressLoading(
  isLoading: _isUploading,
  progress: _uploadProgress,
  child: FileUploadWidget(),
)
```

This loading widget system provides a comprehensive, reusable solution for all loading states in your Flutter application.
