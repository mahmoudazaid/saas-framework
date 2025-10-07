// lib/core/error/error_boundary.dart

import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../ui/styles/app_styles.dart';
import '../exceptions/framework_exception.dart';

/// Error boundary widget to catch and display UI errors
class ErrorBoundary extends StatefulWidget {
  const ErrorBoundary({
    super.key,
    required this.child,
    this.errorBuilder,
  });

  final Widget child;
  final Widget Function(BuildContext context, Object error)? errorBuilder;

  @override
  State<ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  Object? _error;

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return widget.errorBuilder?.call(context, _error!) ??
          _DefaultErrorWidget(error: _error.toString());
    }
    return widget.child;
  }

  @override
  void initState() {
    super.initState();
    FlutterError.onError = (FlutterErrorDetails details) {
      setState(() {
        if (details.exception is FrameworkException) {
          _error = details.exception;
        } else {
          _error = FrameworkException(
            message: 'UI Error occurred',
            originalError: details.exception,
            context: 'ErrorBoundary',
          );
        }
      });
    };
  }
}

/// Default error widget
class _DefaultErrorWidget extends StatelessWidget {
  const _DefaultErrorWidget({required this.error});

  final String error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
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
                AppLocalizations.of(context)!.somethingWentWrong,
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.s),
              Text(
                error,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.l),
              ElevatedButton(
                onPressed: () {
                  // Restart the app or navigate to a safe state
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/',
                    (route) => false,
                  );
                },
                child: Text(AppLocalizations.of(context)!.restartApp),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
