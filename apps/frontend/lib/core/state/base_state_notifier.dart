// lib/core/state/base_state_notifier.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../exceptions/framework_exception.dart';

/// Base state class for all application states
abstract class BaseState {
  const BaseState({
    this.isLoading = false,
    this.error,
    this.lastUpdated,
  });

  final bool isLoading;
  final String? error;
  final DateTime? lastUpdated;

  BaseState copyWith({
    bool? isLoading,
    String? error,
    DateTime? lastUpdated,
  });

  bool get hasError => error != null;
  bool get isSuccess => !isLoading && !hasError;
}

/// Base state notifier providing common state management functionality
abstract class BaseStateNotifier<T extends BaseState> extends StateNotifier<T> {
  BaseStateNotifier(T initialState) : super(initialState);

  /// Handle async operations with automatic loading and error states
  Future<void> handleOperation({
    required Future<void> Function() operation,
    bool showLoading = true,
  }) async {
    try {
      if (showLoading) setLoading();
      await operation();
    } catch (error) {
      if (error is FrameworkException) {
        setError(error.message);
      } else {
        setError(FrameworkException(
          message: 'Operation failed',
          originalError: error,
          context: 'BaseStateNotifier.handleOperation',
        ).message);
      }
    }
  }

  /// Set loading state
  void setLoading() {
    state = state.copyWith(isLoading: true, error: null) as T;
  }

  /// Set error state
  void setError(String error) {
    state = state.copyWith(isLoading: false, error: error) as T;
  }

  /// Set success state
  void setSuccess(T newState) {
    state = newState.copyWith(
      isLoading: false,
      error: null,
      lastUpdated: DateTime.now(),
    ) as T;
  }

  /// Clear error state
  void clearError() {
    state = state.copyWith(error: null) as T;
  }

  /// Refresh data
  Future<void> refresh() async {
    try {
      // Override in subclasses
    } catch (error) {
      if (error is FrameworkException) {
        setError(error.message);
      } else {
        setError(FrameworkException(
          message: 'Refresh failed',
          originalError: error,
          context: 'BaseStateNotifier.refresh',
        ).message);
      }
    }
  }

  /// Retry failed operation
  Future<void> retry() async {
    try {
      clearError();
      await refresh();
    } catch (error) {
      if (error is FrameworkException) {
        setError(error.message);
      } else {
        setError(FrameworkException(
          message: 'Retry failed',
          originalError: error,
          context: 'BaseStateNotifier.retry',
        ).message);
      }
    }
  }
}
