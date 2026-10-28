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

/// The border styling of the toast card.
enum SonnerStyle {
  /// Standard uniform thin border.
  standard,

  /// High-contrast 4px thick colored accent bar on the left edge.
  leftAccent,
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
    this.style = SonnerStyle.standard,
    this.duration = const Duration(milliseconds: 4000),
    this.action,
    this.cancelAction,
    this.icon,
    this.customWidget,
    this.onTap,
    this.dismissible = true,
    this.closeButton = true,
    this.showProgressBar = true,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  final String id;
  final String title;
  final String? description;
  final SonnerType type;
  final SonnerStyle style;
  final Duration? duration;
  final SonnerAction? action;
  final SonnerAction? cancelAction;
  final Widget? icon;
  final Widget? customWidget;
  final VoidCallback? onTap;
  final bool dismissible;
  final bool closeButton;
  final bool showProgressBar;
  final DateTime createdAt;

  SonnerToast copyWith({
    String? id,
    String? title,
    String? description,
    SonnerType? type,
    SonnerStyle? style,
    Duration? duration,
    SonnerAction? action,
    SonnerAction? cancelAction,
    Widget? icon,
    Widget? customWidget,
    VoidCallback? onTap,
    bool? dismissible,
    bool? closeButton,
    bool? showProgressBar,
    DateTime? createdAt,
  }) {
    return SonnerToast(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      style: style ?? this.style,
      duration: duration ?? this.duration,
      action: action ?? this.action,
      cancelAction: cancelAction ?? this.cancelAction,
      icon: icon ?? this.icon,
      customWidget: customWidget ?? this.customWidget,
      onTap: onTap ?? this.onTap,
      dismissible: dismissible ?? this.dismissible,
      closeButton: closeButton ?? this.closeButton,
      showProgressBar: showProgressBar ?? this.showProgressBar,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
