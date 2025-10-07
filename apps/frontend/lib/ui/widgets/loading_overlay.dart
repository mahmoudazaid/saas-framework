// lib/ui/widgets/loading_overlay.dart

import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../styles/app_styles.dart';

/// A loading overlay widget that provides smooth transitions between screens
/// with dimming background and loading progress indicator
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

  /// Whether the loading overlay should be visible
  final bool isLoading;

  /// Custom loading message (optional)
  final String? message;

  /// Background color for the overlay
  final Color? backgroundColor;

  /// Opacity of the background dimming
  final double opacity;

  /// Color of the loading indicator
  final Color? indicatorColor;

  /// Size of the loading indicator
  final double indicatorSize;

  /// Whether to show a progress indicator or just a spinner
  final bool showProgress;

  /// Progress value (0.0 to 1.0) when showProgress is true
  final double? progress;

  /// Duration of the fade in/out animation
  final Duration animationDuration;

  /// Curve for the fade animation
  final Curve animationCurve;

  @override
  Widget build(BuildContext context) {
    if (!isLoading) return const SizedBox.shrink();

    return AnimatedOpacity(
      opacity: isLoading ? 1.0 : 0.0,
      duration: animationDuration,
      curve: animationCurve,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: backgroundColor?.withValues(alpha: opacity) ??
            Colors.black.withValues(alpha: opacity),
        child: Center(
          child: _buildLoadingContent(context),
        ),
      ),
    );
  }

  Widget _buildLoadingContent(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final loadingMessage = message ?? l10n!.loading;
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildLoadingIndicator(theme),
        const SizedBox(height: AppSpacing.m),
        _buildLoadingText(context, loadingMessage, theme),
        if (showProgress && progress != null) ...[
          const SizedBox(height: AppSpacing.s * 1.5),
          _buildProgressIndicator(theme),
        ],
      ],
    );
  }

  Widget _buildLoadingIndicator(ThemeData theme) {
    if (showProgress && progress != null) {
      return SizedBox(
        width: indicatorSize,
        height: indicatorSize,
        child: CircularProgressIndicator(
          value: progress,
          strokeWidth: 3.0,
          valueColor: AlwaysStoppedAnimation<Color>(
            indicatorColor ?? theme.colorScheme.primary,
          ),
        ),
      );
    }

    return SizedBox(
      width: indicatorSize,
      height: indicatorSize,
      child: CircularProgressIndicator(
        strokeWidth: 3.0,
        valueColor: AlwaysStoppedAnimation<Color>(
          indicatorColor ?? theme.colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildLoadingText(
      BuildContext context, String message, ThemeData theme) {
    return Text(
      message,
      style: theme.textTheme.bodyLarge?.copyWith(
        color: theme.colorScheme.onSurface,
        fontWeight: FontWeight.w500,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildProgressIndicator(ThemeData theme) {
    return Container(
      width: AppStyles.progressBarWidth,
      height: AppStyles.progressBarHeight,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(2),
        child: LinearProgressIndicator(
          value: progress,
          backgroundColor:
              Colors.transparent, // This is intentional for overlay
          valueColor: AlwaysStoppedAnimation<Color>(
            indicatorColor ?? theme.colorScheme.primary,
          ),
        ),
      ),
    );
  }
}

/// A wrapper widget that shows loading overlay over its child
class LoadingOverlayWrapper extends StatelessWidget {
  const LoadingOverlayWrapper({
    super.key,
    required this.child,
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

  /// The child widget to display
  final Widget child;

  /// Whether the loading overlay should be visible
  final bool isLoading;

  /// Custom loading message (optional)
  final String? message;

  /// Background color for the overlay
  final Color? backgroundColor;

  /// Opacity of the background dimming
  final double opacity;

  /// Color of the loading indicator
  final Color? indicatorColor;

  /// Size of the loading indicator
  final double indicatorSize;

  /// Whether to show a progress indicator or just a spinner
  final bool showProgress;

  /// Progress value (0.0 to 1.0) when showProgress is true
  final double? progress;

  /// Duration of the fade in/out animation
  final Duration animationDuration;

  /// Curve for the fade animation
  final Curve animationCurve;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        LoadingOverlay(
          isLoading: isLoading,
          message: message,
          backgroundColor: backgroundColor,
          opacity: opacity,
          indicatorColor: indicatorColor,
          indicatorSize: indicatorSize,
          showProgress: showProgress,
          progress: progress,
          animationDuration: animationDuration,
          animationCurve: animationCurve,
        ),
      ],
    );
  }
}

/// A loading screen widget for full-screen loading states
class LoadingScreen extends StatelessWidget {
  const LoadingScreen({
    super.key,
    this.message,
    this.backgroundColor,
    this.indicatorColor,
    this.indicatorSize = 50.0,
    this.showProgress = false,
    this.progress,
    this.animationDuration = const Duration(milliseconds: 300),
    this.animationCurve = Curves.easeInOut,
  });

  /// Custom loading message (optional)
  final String? message;

  /// Background color for the screen
  final Color? backgroundColor;

  /// Color of the loading indicator
  final Color? indicatorColor;

  /// Size of the loading indicator
  final double indicatorSize;

  /// Whether to show a progress indicator or just a spinner
  final bool showProgress;

  /// Progress value (0.0 to 1.0) when showProgress is true
  final double? progress;

  /// Duration of the fade in/out animation
  final Duration animationDuration;

  /// Curve for the fade animation
  final Curve animationCurve;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.surface,
      body: LoadingOverlay(
        isLoading: true,
        message: message,
        backgroundColor: backgroundColor,
        opacity: 1.0,
        indicatorColor: indicatorColor,
        indicatorSize: indicatorSize,
        showProgress: showProgress,
        progress: progress,
        animationDuration: animationDuration,
        animationCurve: animationCurve,
      ),
    );
  }
}
