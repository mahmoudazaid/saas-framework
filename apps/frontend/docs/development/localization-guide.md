# Localization Guide

## 🌍 **Overview**

This guide explains how to use the localization system in our Flutter framework. The framework supports multiple languages and provides a clean, type-safe way to manage translations.

## 🏗️ **Architecture**

### **Localization Structure**
```
lib/
├── l10n/
│   ├── app_en.arb              # English translations (source)
│   ├── app_es.arb              # Spanish translations (source)
│   ├── app_fr.arb              # French translations (source)
│   ├── app_localizations.dart  # Generated (main delegate)
│   └── app_localizations_*.dart # Generated (language-specific)
├── l10n.yaml                   # Configuration
└── pubspec.yaml                # Dependencies
```

## ⚙️ **Configuration**

### **l10n.yaml Configuration**
```yaml
# l10n.yaml
arb-dir: lib/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
output-class: AppLocalizations
```

### **pubspec.yaml Dependencies**
```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter
  intl: ^0.20.2

flutter:
  generate: true
```

## 📝 **Creating Translations**

### **ARB File Format**
```json
// lib/l10n/app_en.arb
{
  "appTitle": "Generic Framework App",
  "splashTitle": "Welcome",
  "splashSubtitle": "Loading your experience...",
  "homeTitle": "Home",
  "homeSubtitle": "Your dashboard",
  "loadEntities": "Load Entities",
  "refresh": "Refresh",
  "retry": "Retry",
  "noEntities": "No entities found",
  "noEntitiesDescription": "Start by loading some entities or check your connection.",
  "errorOccurred": "An error occurred",
  "errorOccurredDescription": "Something went wrong. Please try again.",
  "loading": "Loading...",
  "entityName": "Entity",
  "entityDescription": "Description",
  "lastUpdated": "Last updated",
  "unknownError": "Unknown error occurred",
  "networkError": "Network error. Please check your connection.",
  "validationError": "Validation error",
  "authenticationError": "Authentication required",
  "entityNotFound": "Entity not found",
  "operationFailed": "Operation failed",
  "welcomeMessage": "Welcome, {name}!",
  "itemCount": "{count, plural, =0{No items} =1{One item} other{{count} items}}",
  "lastSeen": "Last seen {date}",
  "@welcomeMessage": {
    "description": "Welcome message with user name",
    "placeholders": {
      "name": {
        "type": "String"
      }
    }
  },
  "@itemCount": {
    "description": "Item count with pluralization",
    "placeholders": {
      "count": {
        "type": "int"
      }
    }
  },
  "@lastSeen": {
    "description": "Last seen date",
    "placeholders": {
      "date": {
        "type": "DateTime"
      }
    }
  }
}
```

### **Adding New Languages**
```json
// lib/l10n/app_es.arb (Spanish)
{
  "appTitle": "Aplicación de Marco Genérico",
  "splashTitle": "Bienvenido",
  "splashSubtitle": "Cargando tu experiencia...",
  "homeTitle": "Inicio",
  "homeSubtitle": "Tu panel de control",
  "loadEntities": "Cargar Entidades",
  "refresh": "Actualizar",
  "retry": "Reintentar",
  "noEntities": "No se encontraron entidades",
  "noEntitiesDescription": "Comienza cargando algunas entidades o verifica tu conexión.",
  "errorOccurred": "Ocurrió un error",
  "errorOccurredDescription": "Algo salió mal. Por favor, inténtalo de nuevo.",
  "loading": "Cargando...",
  "entityName": "Entidad",
  "entityDescription": "Descripción",
  "lastUpdated": "Última actualización",
  "unknownError": "Error desconocido",
  "networkError": "Error de red. Por favor, verifica tu conexión.",
  "validationError": "Error de validación",
  "authenticationError": "Autenticación requerida",
  "entityNotFound": "Entidad no encontrada",
  "operationFailed": "Operación fallida",
  "welcomeMessage": "¡Bienvenido, {name}!",
  "itemCount": "{count, plural, =0{Sin elementos} =1{Un elemento} other{{count} elementos}}",
  "lastSeen": "Visto por última vez {date}"
}
```

## 🔧 **Generating Localization Files**

### **Generate Localization Files**
```bash
# Generate all localization files
flutter gen-l10n

# Generate and watch for changes
flutter gen-l10n --watch
```

### **Generated Files Structure**
After running `flutter gen-l10n`, you'll get:
```
lib/l10n/
├── app_en.arb                   # Source files (committed)
├── app_es.arb                   # Source files (committed)
├── app_fr.arb                   # Source files (committed)
├── app_localizations.dart       # Generated (ignored)
├── app_localizations_en.dart    # Generated (ignored)
├── app_localizations_es.dart    # Generated (ignored)
└── app_localizations_fr.dart    # Generated (ignored)
```

## 🚀 **Using Localization**

### **App Configuration**
```dart
// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Generic Framework App',
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: HomeScreen(),
    );
  }
}
```

### **Using in Widgets**
```dart
// lib/features/home/presentation/screens/home_screen.dart
import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n?.homeTitle ?? 'Home'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Text(l10n?.homeSubtitle ?? 'Your dashboard'),
          ElevatedButton(
            onPressed: () {},
            child: Text(l10n?.loadEntities ?? 'Load Entities'),
          ),
        ],
      ),
    );
  }
}
```

### **Using with Parameters**
```dart
// Using simple parameters
Text(l10n?.welcomeMessage('John') ?? 'Welcome, John!')

// Using pluralization
Text(l10n?.itemCount(5) ?? '5 items')

// Using date formatting
Text(l10n?.lastSeen(DateTime.now()) ?? 'Last seen now')
```

### **Safe Localization Access**
```dart
// lib/core/utils/localization_helper.dart
class LocalizationHelper {
  static String getString(BuildContext context, String Function(AppLocalizations) getter) {
    final l10n = AppLocalizations.of(context);
    if (l10n != null) {
      return getter(l10n);
    }
    return 'Localization not available';
  }
  
  static String getStringWithFallback(
    BuildContext context,
    String Function(AppLocalizations) getter,
    String fallback,
  ) {
    final l10n = AppLocalizations.of(context);
    if (l10n != null) {
      return getter(l10n);
    }
    return fallback;
  }
}

// Usage
Text(LocalizationHelper.getString(
  context,
  (l10n) => l10n.homeTitle,
))

Text(LocalizationHelper.getStringWithFallback(
  context,
  (l10n) => l10n.homeTitle,
  'Home', // fallback
))
```

## 🎨 **Advanced Features**

### **Pluralization**
```json
// app_en.arb
{
  "itemCount": "{count, plural, =0{No items} =1{One item} other{{count} items}}",
  "messageCount": "{count, plural, =0{No messages} =1{One message} other{{count} messages}}"
}
```

```dart
// Usage
Text(l10n?.itemCount(0) ?? 'No items')    // "No items"
Text(l10n?.itemCount(1) ?? 'One item')    // "One item"
Text(l10n?.itemCount(5) ?? '5 items')     // "5 items"
```

### **Date and Number Formatting**
```json
// app_en.arb
{
  "lastSeen": "Last seen {date}",
  "price": "Price: {amount}",
  "@lastSeen": {
    "placeholders": {
      "date": {
        "type": "DateTime",
        "format": "yMMMd"
      }
    }
  },
  "@price": {
    "placeholders": {
      "amount": {
        "type": "double",
        "format": "currency"
      }
    }
  }
}
```

### **Gender and Select**
```json
// app_en.arb
{
  "welcomeMessage": "{gender, select, male{Welcome, Mr. {name}} female{Welcome, Ms. {name}} other{Welcome, {name}}}",
  "@welcomeMessage": {
    "placeholders": {
      "gender": {
        "type": "String"
      },
      "name": {
        "type": "String"
      }
    }
  }
}
```

## 🧪 **Testing Localization**

### **Localization Tests**
```dart
// test/localization/localization_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:generic_framework_app/l10n/app_localizations.dart';

void main() {
  group('Localization Tests', () {
    testWidgets('should display English text', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: const TestWidget(),
        ),
      );
      
      expect(find.text('Generic Framework App'), findsOneWidget);
    });
    
    testWidgets('should display Spanish text', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('es'),
          home: const TestWidget(),
        ),
      );
      
      expect(find.text('Aplicación de Marco Genérico'), findsOneWidget);
    });
  });
}

class TestWidget extends StatelessWidget {
  const TestWidget({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Text(l10n?.appTitle ?? '');
  }
}
```

## 📚 **Best Practices**

1. **Always provide fallbacks** for null localization
2. **Use descriptive keys** that explain the context
3. **Group related translations** in the same ARB file
4. **Test all supported languages** in your test suite
5. **Use parameters** for dynamic content
6. **Leverage pluralization** for count-based messages
7. **Format dates and numbers** appropriately for each locale
8. **Keep translations consistent** across the app
9. **Use comments** in ARB files to explain context
10. **Generate files automatically** in CI/CD pipeline

## 🔧 **Troubleshooting**

### **Common Issues**

1. **Missing translations**: Check if the key exists in all ARB files
2. **Generation errors**: Verify l10n.yaml configuration
3. **Build failures**: Ensure all dependencies are properly configured
4. **Runtime errors**: Always check for null localization

### **Debug Commands**
```bash
# Check for missing translations
flutter gen-l10n --verbose

# Verify configuration
flutter analyze

# Test specific locale
flutter test --dart-define=FLUTTER_TEST_LOCALE=es
```

This localization guide provides everything you need to implement robust, multi-language support in your Flutter applications.
