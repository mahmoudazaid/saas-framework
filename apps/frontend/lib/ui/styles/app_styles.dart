// lib/ui/styles/app_styles.dart

import 'package:flutter/material.dart';

/// App spacing constants
class AppSpacing {
  // Base spacing unit: 4px
  static const double baseUnit = 4.0;

  // Spacing scale
  static const double xs = baseUnit * 1; // 4px
  static const double s = baseUnit * 2; // 8px
  static const double m = baseUnit * 4; // 16px
  static const double l = baseUnit * 6; // 24px
  static const double xl = baseUnit * 8; // 32px
  static const double xxl = baseUnit * 12; // 48px
  static const double xxxl = baseUnit * 16; // 64px

  // Component spacing
  static const EdgeInsets paddingXS = EdgeInsets.all(xs);
  static const EdgeInsets paddingS = EdgeInsets.all(s);
  static const EdgeInsets paddingM = EdgeInsets.all(m);
  static const EdgeInsets paddingL = EdgeInsets.all(l);
  static const EdgeInsets paddingXL = EdgeInsets.all(xl);

  // Horizontal spacing
  static const EdgeInsets paddingHorizontalS =
      EdgeInsets.symmetric(horizontal: s);
  static const EdgeInsets paddingHorizontalM =
      EdgeInsets.symmetric(horizontal: m);
  static const EdgeInsets paddingHorizontalL =
      EdgeInsets.symmetric(horizontal: l);

  // Vertical spacing
  static const EdgeInsets paddingVerticalS = EdgeInsets.symmetric(vertical: s);
  static const EdgeInsets paddingVerticalM = EdgeInsets.symmetric(vertical: m);
  static const EdgeInsets paddingVerticalL = EdgeInsets.symmetric(vertical: l);
}

/// App styles constants
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
  static const double iconXXL = 64.0;

  // Component sizes
  static const double progressBarHeight = 4.0;
  static const double progressBarWidth = 200.0;
  static const double loadingOverlaySpacing = 16.0;
  static const double loadingOverlayTextSpacing = 12.0;

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
