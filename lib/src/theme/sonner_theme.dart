import 'package:flutter/material.dart';

/// Theming and styling configuration for [flutter_sonner].
@immutable
class SonnerTheme {
  const SonnerTheme({
    required this.backgroundColor,
    required this.textColor,
    required this.descriptionColor,
    required this.borderColor,
    required this.actionBackgroundColor,
    required this.actionTextColor,
    required this.closeButtonColor,
    this.successColor = const Color(0xFF10B981),
    this.errorColor = const Color(0xFFEF4444),
    this.warningColor = const Color(0xFFF59E0B),
    this.infoColor = const Color(0xFF3B82F6),
    this.borderRadius = 10.0,
    this.width = 360.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
    this.visibleCardsLimit = 3,
    this.depthScaleFactor = 0.05,
    this.depthOffsetFactor = 12.0,
    this.fontFamily,
    this.shadowColor = const Color(0x33000000),
    this.elevation = 8.0,
  });

  final Color backgroundColor;
  final Color textColor;
  final Color descriptionColor;
  final Color borderColor;
  final Color actionBackgroundColor;
  final Color actionTextColor;
  final Color closeButtonColor;

  final Color successColor;
  final Color errorColor;
  final Color warningColor;
  final Color infoColor;

  final double borderRadius;
  final double width;
  final EdgeInsetsGeometry padding;
  final int visibleCardsLimit;
  final double depthScaleFactor;
  final double depthOffsetFactor;
  final String? fontFamily;
  final Color shadowColor;
  final double elevation;

  /// Sleek obsidian dark theme matching modern developer tooling.
  factory SonnerTheme.dark() {
    return const SonnerTheme(
      backgroundColor: Color(0xFF18181B),
      textColor: Color(0xFFFAFAFA),
      descriptionColor: Color(0xFFA1A1AA),
      borderColor: Color(0xFF27272A),
      actionBackgroundColor: Color(0xFF27272A),
      actionTextColor: Color(0xFFFAFAFA),
      closeButtonColor: Color(0xFF71717A),
      shadowColor: Color(0x66000000),
      elevation: 10.0,
    );
  }

  /// Clean, crisp white light theme with subtle borders.
  factory SonnerTheme.light() {
    return const SonnerTheme(
      backgroundColor: Colors.white,
      textColor: Color(0xFF09090B),
      descriptionColor: Color(0xFF71717A),
      borderColor: Color(0xFFE4E4E7),
      actionBackgroundColor: Color(0xFF09090B),
      actionTextColor: Colors.white,
      closeButtonColor: Color(0xFFA1A1AA),
      shadowColor: Color(0x1A000000),
      elevation: 6.0,
    );
  }

  /// Frosted glassmorphic theme.
  factory SonnerTheme.glass() {
    return const SonnerTheme(
      backgroundColor: Color(0xCC18181B),
      textColor: Color(0xFFFAFAFA),
      descriptionColor: Color(0xFFD4D4D8),
      borderColor: Color(0x40FFFFFF),
      actionBackgroundColor: Color(0x33FFFFFF),
      actionTextColor: Colors.white,
      closeButtonColor: Color(0xFFA1A1AA),
      shadowColor: Color(0x40000000),
      elevation: 12.0,
    );
  }

  SonnerTheme copyWith({
    Color? backgroundColor,
    Color? textColor,
    Color? descriptionColor,
    Color? borderColor,
    Color? actionBackgroundColor,
    Color? actionTextColor,
    Color? closeButtonColor,
    Color? successColor,
    Color? errorColor,
    Color? warningColor,
    Color? infoColor,
    double? borderRadius,
    double? width,
    EdgeInsetsGeometry? padding,
    int? visibleCardsLimit,
    double? depthScaleFactor,
    double? depthOffsetFactor,
    String? fontFamily,
    Color? shadowColor,
    double? elevation,
  }) {
    return SonnerTheme(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textColor: textColor ?? this.textColor,
      descriptionColor: descriptionColor ?? this.descriptionColor,
      borderColor: borderColor ?? this.borderColor,
      actionBackgroundColor:
          actionBackgroundColor ?? this.actionBackgroundColor,
      actionTextColor: actionTextColor ?? this.actionTextColor,
      closeButtonColor: closeButtonColor ?? this.closeButtonColor,
      successColor: successColor ?? this.successColor,
      errorColor: errorColor ?? this.errorColor,
      warningColor: warningColor ?? this.warningColor,
      infoColor: infoColor ?? this.infoColor,
      borderRadius: borderRadius ?? this.borderRadius,
      width: width ?? this.width,
      padding: padding ?? this.padding,
      visibleCardsLimit: visibleCardsLimit ?? this.visibleCardsLimit,
      depthScaleFactor: depthScaleFactor ?? this.depthScaleFactor,
      depthOffsetFactor: depthOffsetFactor ?? this.depthOffsetFactor,
      fontFamily: fontFamily ?? this.fontFamily,
      shadowColor: shadowColor ?? this.shadowColor,
      elevation: elevation ?? this.elevation,
    );
  }
}
