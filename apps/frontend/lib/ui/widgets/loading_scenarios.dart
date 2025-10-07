// lib/ui/widgets/loading_scenarios.dart

import 'package:flutter/material.dart';
import '../../core/exceptions/framework_exception.dart';
import '../../l10n/app_localizations.dart';
import 'loading_overlay.dart';

/// Common loading scenarios for the Flutter framework
///
/// This file provides pre-configured loading overlays for common
/// use cases in the application.
class LoadingScenarios {
  /// Loading overlay for data fetching
  static Widget dataLoading({
    required bool isLoading,
    Widget? child,
    String? message,
  }) {
    return LoadingOverlayWrapper(
      isLoading: isLoading,
      message: message,
      child: child ?? const SizedBox.shrink(),
    );
  }

  /// Loading overlay for navigation transitions
  static Widget navigationLoading({
    required bool isLoading,
    Widget? child,
    String? message,
  }) {
    return LoadingOverlayWrapper(
      isLoading: isLoading,
      message: message,
      opacity: 0.8,
      child: child ?? const SizedBox.shrink(),
    );
  }

  /// Loading overlay for form submission
  static Widget formSubmissionLoading({
    required bool isLoading,
    Widget? child,
    String? message,
  }) {
    return LoadingOverlayWrapper(
      isLoading: isLoading,
      message: message,
      opacity: 0.6,
      child: child ?? const SizedBox.shrink(),
    );
  }

  /// Loading overlay with progress indicator
  static Widget progressLoading({
    required bool isLoading,
    required double progress,
    Widget? child,
    String? message,
  }) {
    return LoadingOverlayWrapper(
      isLoading: isLoading,
      message: message,
      showProgress: true,
      progress: progress,
      child: child ?? const SizedBox.shrink(),
    );
  }

  /// Full screen loading for app initialization
  static Widget appInitializationLoading({
    String? message,
  }) {
    return LoadingScreen(
      message: message,
      showProgress: true,
      progress: 0.5,
    );
  }
}

/// Localized loading messages helper
class LoadingMessages {
  /// Get localized loading message based on context
  static String getLoadingMessage(BuildContext context, LoadingType type) {
    final l10n = AppLocalizations.of(context);

    switch (type) {
      case LoadingType.data:
        return l10n!.loadingData;
      case LoadingType.navigation:
        return l10n!.navigating;
      case LoadingType.processing:
        return l10n!.processing;
      case LoadingType.general:
        return l10n!.loading;
      case LoadingType.wait:
        return l10n!.pleaseWait;
    }
  }
}

/// Types of loading scenarios
enum LoadingType {
  data,
  navigation,
  processing,
  general,
  wait,
}

/// A widget that provides loading state management
class LoadingStateManager extends StatefulWidget {
  const LoadingStateManager({
    super.key,
    required this.child,
    this.onLoad,
    this.loadingType = LoadingType.general,
    this.customMessage,
  });

  final Widget child;
  final Future<void> Function()? onLoad;
  final LoadingType loadingType;
  final String? customMessage;

  @override
  State<LoadingStateManager> createState() => _LoadingStateManagerState();
}

class _LoadingStateManagerState extends State<LoadingStateManager> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.onLoad != null) {
      _loadData();
    }
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await widget.onLoad!();
    } catch (error) {
      if (error is FrameworkException) {
        // Handle framework exceptions
        debugPrint('Loading failed: ${error.message}');
      } else {
        // Handle other exceptions
        debugPrint('Loading failed: ${error.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final message = widget.customMessage ??
        LoadingMessages.getLoadingMessage(context, widget.loadingType);

    return LoadingScenarios.dataLoading(
      isLoading: _isLoading,
      message: message,
      child: widget.child,
    );
  }
}

/// A widget for handling async operations with loading states
class AsyncOperationHandler extends StatefulWidget {
  const AsyncOperationHandler({
    super.key,
    required this.child,
    required this.operation,
    this.loadingType = LoadingType.processing,
    this.customMessage,
    this.onSuccess,
    this.onError,
  });

  final Widget child;
  final Future<void> Function() operation;
  final LoadingType loadingType;
  final String? customMessage;
  final VoidCallback? onSuccess;
  final Function(dynamic error)? onError;

  @override
  State<AsyncOperationHandler> createState() => _AsyncOperationHandlerState();
}

class _AsyncOperationHandlerState extends State<AsyncOperationHandler> {
  bool _isLoading = false;

  Future<void> _executeOperation() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await widget.operation();
      widget.onSuccess?.call();
    } catch (error) {
      widget.onError?.call(error);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final message = widget.customMessage ??
        LoadingMessages.getLoadingMessage(context, widget.loadingType);

    return LoadingScenarios.formSubmissionLoading(
      isLoading: _isLoading,
      message: message,
      child: GestureDetector(
        onTap: _executeOperation,
        child: widget.child,
      ),
    );
  }
}
