# Flutter Design System

> **🎨 Material Design Implementation for Flutter Framework**

This document outlines the design system implementation for the Flutter framework, providing consistent, accessible, and reusable UI components.

## 📋 **Table of Contents**

1. [Design System Overview](#design-system-overview)
2. [Design Tokens](#design-tokens)
3. [Color System](#color-system)
4. [Typography](#typography)
5. [Spacing](#spacing)
6. [Components](#components)
7. [Theming](#theming)
8. [Accessibility](#accessibility)
9. [Responsive Design](#responsive-design)
10. [Best Practices](#best-practices)

## 🎨 **Design System Overview**

The Flutter framework implements a comprehensive design system based on:

- **Material Design 3**: Google's latest design language
- **Generic Components**: Reusable across different domains
- **Accessibility**: WCAG 2.1 compliance
- **Responsive Design**: Mobile and web adaptation
- **Consistent Theming**: Light and dark theme support

### **Design Principles**

- **Consistency**: Uniform look and feel across the app
- **Accessibility**: Inclusive design for all users
- **Scalability**: Easy to extend and modify
- **Performance**: Optimized for smooth interactions
- **Generic**: Reusable across different business domains

## 🎯 **Design Tokens**

### **App Styles Configuration**

```dart
// lib/ui/styles/app_styles.dart
class AppStyles {
  // Spacing
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXL = 32.0;
  static const double spacingXXL = 48.0;

  // Border Radius
  static const double radiusS = 4.0;
  static const double radiusM = 8.0;
  static const double radiusL = 12.0;
  static const double radiusXL = 16.0;
  static const double radiusXXL = 24.0;

  // Icon Sizes
  static const double iconXS = 16.0;
  static const double iconS = 20.0;
  static const double iconM = 24.0;
  static const double iconL = 32.0;
  static const double iconXL = 48.0;

  // Elevation
  static const double elevationS = 2.0;
  static const double elevationM = 4.0;
  static const double elevationL = 8.0;
  static const double elevationXL = 16.0;

  // Button Styles
  static ButtonStyle primaryButtonStyle(BuildContext context) {
    return ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(
        horizontal: spacingL,
        vertical: spacingM,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusM),
      ),
      elevation: elevationS,
    );
  }

  static InputDecoration inputDecoration({
    required String labelText,
    String? hintText,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusM),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: spacingM,
        vertical: spacingS,
      ),
    );
  }
}
```

## 🎨 **Color System**

### **Color Palette**

```dart
// lib/ui/styles/app_theme.dart
class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF6750A4);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFFEADDFF);
  static const Color onPrimaryContainer = Color(0xFF21005D);

  // Secondary Colors
  static const Color secondary = Color(0xFF625B71);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFFE8DEF8);
  static const Color onSecondaryContainer = Color(0xFF1D192B);

  // Tertiary Colors
  static const Color tertiary = Color(0xFF7D5260);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color tertiaryContainer = Color(0xFFFFD8E4);
  static const Color onTertiaryContainer = Color(0xFF31111D);

  // Error Colors
  static const Color error = Color(0xFFBA1A1A);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onErrorContainer = Color(0xFF410002);

  // Surface Colors
  static const Color surface = Color(0xFFFFFBFE);
  static const Color onSurface = Color(0xFF1C1B1F);
  static const Color surfaceVariant = Color(0xFFE7E0EC);
  static const Color onSurfaceVariant = Color(0xFF49454F);

  // Background Colors
  static const Color background = Color(0xFFFFFBFE);
  static const Color onBackground = Color(0xFF1C1B1F);

  // Outline Colors
  static const Color outline = Color(0xFF79747E);
  static const Color outlineVariant = Color(0xFFCAC4D0);

  // Shadow Colors
  static const Color shadow = Color(0xFF000000);
  static const Color scrim = Color(0xFF000000);

  // Inverse Colors
  static const Color inverseSurface = Color(0xFF313033);
  static const Color onInverseSurface = Color(0xFFF4EFF4);
  static const Color inversePrimary = Color(0xFFD0BCFF);

  // Surface Tint
  static const Color surfaceTint = Color(0xFF6750A4);
}
```

### **Color Usage Guidelines**

```dart
// lib/ui/styles/app_theme.dart
class ColorUsage {
  // Primary colors for main actions and branding
  static const Color primary = AppColors.primary;
  static const Color onPrimary = AppColors.onPrimary;

  // Secondary colors for supporting elements
  static const Color secondary = AppColors.secondary;
  static const Color onSecondary = AppColors.onSecondary;

  // Error colors for error states
  static const Color error = AppColors.error;
  static const Color onError = AppColors.onError;

  // Surface colors for backgrounds
  static const Color surface = AppColors.surface;
  static const Color onSurface = AppColors.onSurface;

  // Outline colors for borders and dividers
  static const Color outline = AppColors.outline;
  static const Color outlineVariant = AppColors.outlineVariant;
}
```

## 📝 **Typography**

### **Text Styles**

```dart
// lib/ui/styles/app_theme.dart
class AppTextStyles {
  // Display Styles
  static const TextStyle displayLarge = TextStyle(
    fontSize: 57,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.25,
    height: 1.12,
  );

  static const TextStyle displayMedium = TextStyle(
    fontSize: 45,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.16,
  );

  static const TextStyle displaySmall = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.22,
  );

  // Headline Styles
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.25,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.29,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.33,
  );

  // Title Styles
  static const TextStyle titleLarge = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.27,
  );

  static const TextStyle titleMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.15,
    height: 1.50,
  );

  static const TextStyle titleSmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.43,
  );

  // Body Styles
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
    height: 1.50,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
    height: 1.43,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    height: 1.33,
  );

  // Label Styles
  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.43,
  );

  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    height: 1.33,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    height: 1.45,
  );
}
```

### **Typography Usage**

```dart
// lib/ui/styles/app_theme.dart
class TypographyUsage {
  // Headers
  static const TextStyle pageTitle = AppTextStyles.headlineLarge;
  static const TextStyle sectionTitle = AppTextStyles.headlineMedium;
  static const TextStyle cardTitle = AppTextStyles.titleLarge;

  // Body Text
  static const TextStyle bodyText = AppTextStyles.bodyMedium;
  static const TextStyle caption = AppTextStyles.bodySmall;
  static const TextStyle label = AppTextStyles.labelMedium;

  // Buttons
  static const TextStyle buttonText = AppTextStyles.labelLarge;
  static const TextStyle smallButtonText = AppTextStyles.labelMedium;
}
```

## 📏 **Spacing**

### **Spacing Scale**

```dart
// lib/ui/styles/app_styles.dart
class AppSpacing {
  // Base spacing unit: 4px
  static const double baseUnit = 4.0;

  // Spacing scale
  static const double xs = baseUnit * 1;    // 4px
  static const double s = baseUnit * 2;     // 8px
  static const double m = baseUnit * 4;     // 16px
  static const double l = baseUnit * 6;     // 24px
  static const double xl = baseUnit * 8;    // 32px
  static const double xxl = baseUnit * 12;  // 48px
  static const double xxxl = baseUnit * 16; // 64px

  // Component spacing
  static const EdgeInsets paddingXS = EdgeInsets.all(xs);
  static const EdgeInsets paddingS = EdgeInsets.all(s);
  static const EdgeInsets paddingM = EdgeInsets.all(m);
  static const EdgeInsets paddingL = EdgeInsets.all(l);
  static const EdgeInsets paddingXL = EdgeInsets.all(xl);

  // Horizontal spacing
  static const EdgeInsets paddingHorizontalS = EdgeInsets.symmetric(horizontal: s);
  static const EdgeInsets paddingHorizontalM = EdgeInsets.symmetric(horizontal: m);
  static const EdgeInsets paddingHorizontalL = EdgeInsets.symmetric(horizontal: l);

  // Vertical spacing
  static const EdgeInsets paddingVerticalS = EdgeInsets.symmetric(vertical: s);
  static const EdgeInsets paddingVerticalM = EdgeInsets.symmetric(vertical: m);
  static const EdgeInsets paddingVerticalL = EdgeInsets.symmetric(vertical: l);
}
```

## 🧩 **Components**

### **Loading Components**

The framework includes a comprehensive loading system with smooth transitions and localization support:

```dart
// lib/ui/widgets/loading_scenarios.dart
class LoadingScenarios {
  // Data loading with generic message
  static Widget dataLoading({
    required bool isLoading,
    required Widget child,
    String? customMessage,
  }) {
    return LoadingOverlayWrapper(
      isLoading: isLoading,
      message: customMessage ?? LoadingMessages.dataLoading,
      child: child,
    );
  }

  // Navigation loading with progress
  static Widget navigationLoading({
    required bool isLoading,
    required Widget child,
    double? progress,
  }) {
    return LoadingOverlayWrapper(
      isLoading: isLoading,
      message: LoadingMessages.navigating,
      showProgress: true,
      progress: progress,
      child: child,
    );
  }

  // Form submission loading
  static Widget formLoading({
    required bool isLoading,
    required Widget child,
  }) {
    return LoadingOverlayWrapper(
      isLoading: isLoading,
      message: LoadingMessages.processing,
      child: child,
    );
  }
}
```

### **Button Components**

```dart
// lib/ui/widgets/generic_widgets.dart
class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: AppStyles.primaryButtonStyle(context),
      child: isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: AppStyles.iconS),
                  const SizedBox(width: AppSpacing.s),
                ],
                Text(text, style: TypographyUsage.buttonText),
              ],
            ),
    );
  }
}

class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;

  const SecondaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: isLoading ? null : onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.l,
          vertical: AppSpacing.m,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppStyles.radiusM),
        ),
      ),
      child: isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: AppStyles.iconS),
                  const SizedBox(width: AppSpacing.s),
                ],
                Text(text, style: TypographyUsage.buttonText),
              ],
            ),
    );
  }
}
```

### **Input Components**

```dart
// lib/ui/widgets/generic_widgets.dart
class GenericTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int? maxLines;
  final int? maxLength;

  const GenericTextField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.validator,
    this.keyboardType,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      obscureText: obscureText,
      maxLines: maxLines,
      maxLength: maxLength,
      decoration: AppStyles.inputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
    );
  }
}
```

### **Card Components**

```dart
// lib/ui/widgets/generic_widgets.dart
class EntityCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? description;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const EntityCard({
    super.key,
    required this.title,
    this.subtitle,
    this.description,
    this.leading,
    this.trailing,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: AppStyles.elevationS,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppStyles.radiusM),
      ),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(AppStyles.radiusM),
        child: Padding(
          padding: AppSpacing.paddingM,
          child: Row(
            children: [
              if (leading != null) ...[
                leading!,
                const SizedBox(width: AppSpacing.m),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TypographyUsage.cardTitle,
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        subtitle!,
                        style: TypographyUsage.bodyMedium,
                      ),
                    ],
                    if (description != null) ...[
                      const SizedBox(height: AppSpacing.s),
                      Text(
                        description!,
                        style: TypographyUsage.bodySmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: AppSpacing.m),
                trailing!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
```

### **Loading and Error Components**

```dart
// lib/ui/widgets/loading_overlay.dart
class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({
    super.key,
    required this.isLoading,
    this.message,
    this.backgroundColor,
    this.opacity = 0.7,
    this.indicatorColor,
    this.indicatorSize = 40.0,
    this.showProgress = false,
    this.progress,
    this.animationDuration = const Duration(milliseconds: 300),
    this.animationCurve = Curves.easeInOut,
  });

  final bool isLoading;
  final String? message;
  final Color? backgroundColor;
  final double opacity;
  final Color? indicatorColor;
  final double indicatorSize;
  final bool showProgress;
  final double? progress;
  final Duration animationDuration;
  final Curve animationCurve;

  @override
  Widget build(BuildContext context) {
    if (!isLoading) return const SizedBox.shrink();

    return AnimatedOpacity(
      opacity: isLoading ? 1.0 : 0.0,
      duration: animationDuration,
      curve: animationCurve,
      child: Container(
        color: (backgroundColor ?? Colors.black).withValues(alpha: opacity),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (showProgress && progress != null)
                SizedBox(
                  width: indicatorSize,
                  height: indicatorSize,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 3.0,
                    color: indicatorColor ?? Theme.of(context).colorScheme.primary,
                  ),
                )
              else
                SizedBox(
                  width: indicatorSize,
                  height: indicatorSize,
                  child: CircularProgressIndicator(
                    strokeWidth: 3.0,
                    color: indicatorColor ?? Theme.of(context).colorScheme.primary,
                  ),
                ),
              if (message != null) ...[
                const SizedBox(height: AppSpacing.m),
                Text(
                  message!,
                  style: TypographyUsage.bodyMedium.copyWith(
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class ErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const ErrorWidget({
    super.key,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppSpacing.paddingM,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: AppStyles.iconXL,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: AppSpacing.m),
            Text(
              'Error: $message',
              style: TypographyUsage.bodyMedium,
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppSpacing.l),
              PrimaryButton(
                text: 'Retry',
                onPressed: onRetry,
                icon: Icons.refresh,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class EmptyStateWidget extends StatelessWidget {
  final String message;
  final IconData? icon;
  final Widget? action;

  const EmptyStateWidget({
    super.key,
    required this.message,
    this.icon,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppSpacing.paddingM,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon ?? Icons.inbox_outlined,
              size: AppStyles.iconXL,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: AppSpacing.m),
            Text(
              message,
              style: TypographyUsage.bodyMedium,
              textAlign: TextAlign.center,
            ),
            if (action != null) ...[
              const SizedBox(height: AppSpacing.l),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}
```

## 🎨 **Theming**

### **Light Theme**

```dart
// lib/ui/styles/app_theme.dart
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
      ),
      textTheme: const TextTheme(
        displayLarge: AppTextStyles.displayLarge,
        displayMedium: AppTextStyles.displayMedium,
        displaySmall: AppTextStyles.displaySmall,
        headlineLarge: AppTextStyles.headlineLarge,
        headlineMedium: AppTextStyles.headlineMedium,
        headlineSmall: AppTextStyles.headlineSmall,
        titleLarge: AppTextStyles.titleLarge,
        titleMedium: AppTextStyles.titleMedium,
        titleSmall: AppTextStyles.titleSmall,
        bodyLarge: AppTextStyles.bodyLarge,
        bodyMedium: AppTextStyles.bodyMedium,
        bodySmall: AppTextStyles.bodySmall,
        labelLarge: AppTextStyles.labelLarge,
        labelMedium: AppTextStyles.labelMedium,
        labelSmall: AppTextStyles.labelSmall,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: AppStyles.primaryButtonStyle,
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.l,
            vertical: AppSpacing.m,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppStyles.radiusM),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppStyles.radiusM),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.m,
          vertical: AppSpacing.s,
        ),
      ),
      cardTheme: CardTheme(
        elevation: AppStyles.elevationS,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppStyles.radiusM),
        ),
      ),
    );
  }
}
```

### **Dark Theme**

```dart
// lib/ui/styles/app_theme.dart
class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.dark,
      ),
      textTheme: const TextTheme(
        displayLarge: AppTextStyles.displayLarge,
        displayMedium: AppTextStyles.displayMedium,
        displaySmall: AppTextStyles.displaySmall,
        headlineLarge: AppTextStyles.headlineLarge,
        headlineMedium: AppTextStyles.headlineMedium,
        headlineSmall: AppTextStyles.headlineSmall,
        titleLarge: AppTextStyles.titleLarge,
        titleMedium: AppTextStyles.titleMedium,
        titleSmall: AppTextStyles.titleSmall,
        bodyLarge: AppTextStyles.bodyLarge,
        bodyMedium: AppTextStyles.bodyMedium,
        bodySmall: AppTextStyles.bodySmall,
        labelLarge: AppTextStyles.labelLarge,
        labelMedium: AppTextStyles.labelMedium,
        labelSmall: AppTextStyles.labelSmall,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: AppStyles.primaryButtonStyle,
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.l,
            vertical: AppSpacing.m,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppStyles.radiusM),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppStyles.radiusM),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.m,
          vertical: AppSpacing.s,
        ),
      ),
      cardTheme: CardTheme(
        elevation: AppStyles.elevationS,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppStyles.radiusM),
        ),
      ),
    );
  }
}
```

## ♿ **Accessibility**

### **Accessibility Guidelines**

```dart
// lib/ui/widgets/generic_widgets.dart
class AccessibleButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final String? semanticLabel;
  final bool isLoading;

  const AccessibleButton({
    super.key,
    required this.text,
    this.onPressed,
    this.semanticLabel,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel ?? text,
      button: true,
      enabled: onPressed != null && !isLoading,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        child: Text(text),
      ),
    );
  }
}

class AccessibleTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final String? semanticLabel;

  const AccessibleTextField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.validator,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel ?? label,
      hint: hint,
      textField: true,
      child: TextFormField(
        controller: controller,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
        ),
      ),
    );
  }
}
```

### **Accessibility Testing**

```dart
// test/ui/widgets/accessibility_test.dart
void main() {
  group('Accessibility Tests', () {
    testWidgets('should have proper semantic labels', (tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AccessibleButton(
              text: 'Submit',
              semanticLabel: 'Submit form',
              onPressed: () {},
            ),
          ),
        ),
      );

      // Assert
      expect(find.bySemanticsLabel('Submit form'), findsOneWidget);
    });

    testWidgets('should support screen readers', (tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AccessibleTextField(
              label: 'Name',
              hint: 'Enter your name',
              semanticLabel: 'Name input field',
            ),
          ),
        ),
      );

      // Assert
      expect(find.bySemanticsLabel('Name input field'), findsOneWidget);
    });
  });
}
```

## 📱 **Responsive Design**

### **Breakpoints**

```dart
// lib/ui/styles/app_theme.dart
class AppBreakpoints {
  static const double mobile = 600;
  static const double tablet = 900;
  static const double desktop = 1200;

  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobile;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobile && width < tablet;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= tablet;
  }
}
```

### **Responsive Layout**

```dart
// lib/ui/widgets/generic_widgets.dart
class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    if (AppBreakpoints.isDesktop(context) && desktop != null) {
      return desktop!;
    } else if (AppBreakpoints.isTablet(context) && tablet != null) {
      return tablet!;
    } else {
      return mobile;
    }
  }
}

class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final int mobileColumns;
  final int? tabletColumns;
  final int? desktopColumns;

  const ResponsiveGrid({
    super.key,
    required this.children,
    this.mobileColumns = 1,
    this.tabletColumns,
    this.desktopColumns,
  });

  @override
  Widget build(BuildContext context) {
    int columns = mobileColumns;
    
    if (AppBreakpoints.isDesktop(context) && desktopColumns != null) {
      columns = desktopColumns!;
    } else if (AppBreakpoints.isTablet(context) && tabletColumns != null) {
      columns = tabletColumns!;
    }

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: AppSpacing.m,
        mainAxisSpacing: AppSpacing.m,
      ),
      itemCount: children.length,
      itemBuilder: (context, index) => children[index],
    );
  }
}
```

## ✅ **Best Practices**

### **1. Component Design**
- Create reusable, generic components
- Use consistent naming conventions
- Implement proper accessibility
- Follow Material Design guidelines

### **2. Theming**
- Use design tokens for consistency
- Support both light and dark themes
- Implement proper color contrast
- Use semantic color names

### **3. Responsive Design**
- Design mobile-first
- Use responsive breakpoints
- Test on different screen sizes
- Implement adaptive layouts

### **4. Accessibility**
- Use semantic labels
- Implement proper focus management
- Support screen readers
- Test with accessibility tools

### **5. Performance**
- Use const constructors where possible
- Implement proper widget rebuilding
- Optimize image loading
- Use efficient layouts

## 📝 **Examples**

### **Complete Component Example**

```dart
// lib/ui/widgets/generic_widgets.dart
class EntityDetailsDialog extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? description;
  final List<Widget>? actions;
  final Widget? content;

  const EntityDetailsDialog({
    super.key,
    required this.title,
    this.subtitle,
    this.description,
    this.actions,
    this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppStyles.radiusL),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Padding(
          padding: AppSpacing.paddingL,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TypographyUsage.titleLarge,
                        ),
                        if (subtitle != null) ...[
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            subtitle!,
                            style: TypographyUsage.bodyMedium,
                          ),
                        ],
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              
              // Description
              if (description != null) ...[
                const SizedBox(height: AppSpacing.m),
                Text(
                  description!,
                  style: TypographyUsage.bodyMedium,
                ),
              ],
              
              // Content
              if (content != null) ...[
                const SizedBox(height: AppSpacing.m),
                content!,
              ],
              
              // Actions
              if (actions != null) ...[
                const SizedBox(height: AppSpacing.l),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: actions!,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
```

## 🎯 **Summary**

The Flutter design system provides:

- **Consistent Design**: Uniform look and feel across the app
- **Material Design 3**: Modern, accessible design language
- **Generic Components**: Reusable across different domains
- **Accessibility**: WCAG 2.1 compliant components
- **Responsive Design**: Mobile and web adaptation
- **Theming**: Light and dark theme support
- **Performance**: Optimized for smooth interactions

This design system ensures the Flutter framework provides a consistent, accessible, and maintainable user interface while following Flutter and Material Design best practices.
