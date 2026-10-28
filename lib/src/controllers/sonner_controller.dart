import 'dart:async';
import 'package:flutter/widgets.dart';
import '../models/sonner_data.dart';

/// Global dispatcher for triggering, updating, and dismissing Sonner toasts.
class Sonner {
  Sonner._();

  static final ValueNotifier<List<SonnerToast>> toasts =
      ValueNotifier<List<SonnerToast>>([]);

  static final Map<String, Timer> _activeTimers = {};
  static int _counter = 0;

  /// Shows a general toast message and returns its unique ID.
  static String show(
    String title, {
    String? description,
    SonnerType type = SonnerType.normal,
    SonnerStyle style = SonnerStyle.standard,
    Duration? duration = const Duration(milliseconds: 4000),
    SonnerAction? action,
    SonnerAction? cancelAction,
    Widget? icon,
    Widget? customWidget,
    VoidCallback? onTap,
    bool dismissible = true,
    bool closeButton = true,
    bool showProgressBar = true,
  }) {
    final id = 'sonner_${DateTime.now().millisecondsSinceEpoch}_${++_counter}';

    final toast = SonnerToast(
      id: id,
      title: title,
      description: description,
      type: type,
      style: style,
      duration: duration,
      action: action,
      cancelAction: cancelAction,
      icon: icon,
      customWidget: customWidget,
      onTap: onTap,
      dismissible: dismissible,
      closeButton: closeButton,
      showProgressBar: showProgressBar,
    );

    final current = List<SonnerToast>.from(toasts.value);
    // Insert new toast at beginning (index 0 is front of stack)
    current.insert(0, toast);
    toasts.value = current;

    _scheduleDismissal(id, duration);
    return id;
  }

  /// Triggers a success toast with a green checkmark.
  static String success(
    String title, {
    String? description,
    SonnerStyle style = SonnerStyle.standard,
    Duration? duration = const Duration(milliseconds: 4000),
    SonnerAction? action,
    SonnerAction? cancelAction,
    VoidCallback? onTap,
    bool closeButton = true,
  }) {
    return show(
      title,
      description: description,
      type: SonnerType.success,
      style: style,
      duration: duration,
      action: action,
      cancelAction: cancelAction,
      onTap: onTap,
      closeButton: closeButton,
    );
  }

  /// Triggers an error toast with a red alert icon.
  static String error(
    String title, {
    String? description,
    SonnerStyle style = SonnerStyle.standard,
    Duration? duration = const Duration(milliseconds: 4500),
    SonnerAction? action,
    SonnerAction? cancelAction,
    VoidCallback? onTap,
    bool closeButton = true,
  }) {
    return show(
      title,
      description: description,
      type: SonnerType.error,
      style: style,
      duration: duration,
      action: action,
      cancelAction: cancelAction,
      onTap: onTap,
      closeButton: closeButton,
    );
  }

  /// Triggers an informational toast.
  static String info(
    String title, {
    String? description,
    SonnerStyle style = SonnerStyle.standard,
    Duration? duration = const Duration(milliseconds: 4000),
    SonnerAction? action,
    VoidCallback? onTap,
    bool closeButton = true,
  }) {
    return show(
      title,
      description: description,
      type: SonnerType.info,
      style: style,
      duration: duration,
      action: action,
      onTap: onTap,
      closeButton: closeButton,
    );
  }

  /// Triggers a warning toast.
  static String warning(
    String title, {
    String? description,
    SonnerStyle style = SonnerStyle.standard,
    Duration? duration = const Duration(milliseconds: 4000),
    SonnerAction? action,
    VoidCallback? onTap,
    bool closeButton = true,
  }) {
    return show(
      title,
      description: description,
      type: SonnerType.warning,
      style: style,
      duration: duration,
      action: action,
      onTap: onTap,
      closeButton: closeButton,
    );
  }

  /// Triggers a persistent loading toast with an animated spinner.
  static String loading(
    String title, {
    String? description,
    bool closeButton = false,
  }) {
    return show(
      title,
      description: description,
      type: SonnerType.loading,
      duration: null, // Loading toasts persist until updated or dismissed
      closeButton: closeButton,
    );
  }

  /// Executes an asynchronous [future], presenting a loading spinner during execution,
  /// then seamlessly morphs in-place to a success or error toast upon completion.
  static Future<T> promise<T>(
    Future<T> future, {
    required String loading,
    required String Function(T data) success,
    required String Function(Object error) error,
    String? Function(T data)? successDescription,
    String? Function(Object error)? errorDescription,
    SonnerAction? Function(T data)? successAction,
    Duration? duration = const Duration(milliseconds: 4000),
  }) async {
    final toastId = Sonner.loading(loading);

    try {
      final result = await future;
      update(
        toastId,
        title: success(result),
        description: successDescription?.call(result),
        type: SonnerType.success,
        duration: duration,
        action: successAction?.call(result),
      );
      return result;
    } catch (err) {
      update(
        toastId,
        title: error(err),
        description: errorDescription?.call(err),
        type: SonnerType.error,
        duration: duration,
      );
      rethrow;
    }
  }

  /// Updates an existing toast by its [id] (e.g. from loading -> success).
  static void update(
    String id, {
    String? title,
    String? description,
    SonnerType? type,
    Duration? duration,
    SonnerAction? action,
    SonnerAction? cancelAction,
    Widget? icon,
    Widget? customWidget,
    bool? closeButton,
  }) {
    final current = List<SonnerToast>.from(toasts.value);
    final index = current.indexWhere((t) => t.id == id);
    if (index == -1) return;

    final updatedToast = current[index].copyWith(
      title: title,
      description: description,
      type: type,
      duration: duration,
      action: action,
      cancelAction: cancelAction,
      icon: icon,
      customWidget: customWidget,
      closeButton: closeButton,
    );

    current[index] = updatedToast;
    toasts.value = current;

    _scheduleDismissal(id, duration);
  }

  /// Dismisses a single toast by its [id].
  static void dismiss(String id) {
    _activeTimers[id]?.cancel();
    _activeTimers.remove(id);

    final current = List<SonnerToast>.from(toasts.value);
    current.removeWhere((t) => t.id == id);
    toasts.value = current;
  }

  /// Dismisses all active toasts immediately.
  static void dismissAll() {
    for (final timer in _activeTimers.values) {
      timer.cancel();
    }
    _activeTimers.clear();
    toasts.value = [];
  }

  static void _scheduleDismissal(String id, Duration? duration) {
    _activeTimers[id]?.cancel();
    _activeTimers.remove(id);

    if (duration != null) {
      _activeTimers[id] = Timer(duration, () => dismiss(id));
    }
  }
}
