import 'package:flutter/widgets.dart';

/// The variant type of toast notification.
enum SonnerType {
  normal,
  success,
  error,
  info,
  warning,
  loading,
  custom,
}

/// The screen position anchor where toasts stack and expand.
enum SonnerPosition {
  topRight,
  topCenter,
  topLeft,
  bottomRight,
  bottomCenter,
  bottomLeft;

  bool get isTop =>
      this == SonnerPosition.topRight ||
      this == SonnerPosition.topCenter ||
      this == SonnerPosition.topLeft;

  bool get isBottom => !isTop;
}

/// An interactive button embedded inside the toast card.
@immutable
class SonnerAction {
  const SonnerAction({
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;
}

/// Data model representing an active Sonner toast instance.
class SonnerToast {
  SonnerToast({
    required this.id,
    required this.title,
    this.description,
    this.type = SonnerType.normal,
    this.duration = const Duration(milliseconds: 4000),
    this.action,
    this.cancelAction,
    this.icon,
    this.customWidget,
    this.dismissible = true,
    this.closeButton = true,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  final String id;
  final String title;
  final String? description;
  final SonnerType type;
  final Duration? duration;
  final SonnerAction? action;
  final SonnerAction? cancelAction;
  final Widget? icon;
  final Widget? customWidget;
  final bool dismissible;
  final bool closeButton;
  final DateTime createdAt;

  SonnerToast copyWith({
    String? id,
    String? title,
    String? description,
    SonnerType? type,
    Duration? duration,
    SonnerAction? action,
    SonnerAction? cancelAction,
    Widget? icon,
    Widget? customWidget,
    bool? dismissible,
    bool? closeButton,
    DateTime? createdAt,
  }) {
    return SonnerToast(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      duration: duration ?? this.duration,
      action: action ?? this.action,
      cancelAction: cancelAction ?? this.cancelAction,
      icon: icon ?? this.icon,
      customWidget: customWidget ?? this.customWidget,
      dismissible: dismissible ?? this.dismissible,
      closeButton: closeButton ?? this.closeButton,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
