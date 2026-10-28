import 'package:flutter/material.dart';
import '../controllers/sonner_controller.dart';
import '../models/sonner_data.dart';
import '../theme/sonner_theme.dart';

/// Animated card displaying a single Sonner toast with card-depth stacking,
/// spring transitions, auto-dismiss progress countdown, action buttons, and swipe-to-dismiss.
class SonnerToastCard extends StatefulWidget {
  const SonnerToastCard({
    super.key,
    required this.toast,
    required this.theme,
    required this.depthIndex,
    required this.isExpanded,
    required this.position,
    this.onDismiss,
  });

  final SonnerToast toast;
  final SonnerTheme theme;
  final int depthIndex;
  final bool isExpanded;
  final SonnerPosition position;
  final VoidCallback? onDismiss;

  @override
  State<SonnerToastCard> createState() => _SonnerToastCardState();
}

class _SonnerToastCardState extends State<SonnerToastCard>
    with SingleTickerProviderStateMixin {
  AnimationController? _progressController;

  @override
  void initState() {
    super.initState();
    if (widget.toast.duration != null && widget.toast.showProgressBar) {
      _progressController = AnimationController(
        vsync: this,
        duration: widget.toast.duration,
      )..forward();
    }
  }

  @override
  void didUpdateWidget(SonnerToastCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.toast.duration != oldWidget.toast.duration) {
      _progressController?.dispose();
      _progressController = null;
      if (widget.toast.duration != null && widget.toast.showProgressBar) {
        _progressController = AnimationController(
          vsync: this,
          duration: widget.toast.duration,
        )..forward();
      }
    }
  }

  @override
  void dispose() {
    _progressController?.dispose();
    super.dispose();
  }

  Color _getAccentColor() {
    switch (widget.toast.type) {
      case SonnerType.success:
        return widget.theme.successColor;
      case SonnerType.error:
        return widget.theme.errorColor;
      case SonnerType.warning:
        return widget.theme.warningColor;
      case SonnerType.info:
        return widget.theme.infoColor;
      case SonnerType.loading:
      case SonnerType.normal:
      case SonnerType.custom:
        return widget.theme.actionBackgroundColor;
    }
  }

  Widget _buildTypeIcon() {
    if (widget.toast.icon != null) return widget.toast.icon!;

    switch (widget.toast.type) {
      case SonnerType.success:
        return Icon(Icons.check_circle_rounded,
            color: widget.theme.successColor, size: 20);
      case SonnerType.error:
        return Icon(Icons.error_rounded,
            color: widget.theme.errorColor, size: 20);
      case SonnerType.warning:
        return Icon(Icons.warning_amber_rounded,
            color: widget.theme.warningColor, size: 20);
      case SonnerType.info:
        return Icon(Icons.info_rounded,
            color: widget.theme.infoColor, size: 20);
      case SonnerType.loading:
        return SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2.0,
            valueColor: AlwaysStoppedAnimation<Color>(widget.theme.textColor),
          ),
        );
      case SonnerType.normal:
      case SonnerType.custom:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.toast.customWidget != null) {
      return widget.toast.customWidget!;
    }

    // Depth calculation
    final effectiveIndex =
        widget.depthIndex.clamp(0, widget.theme.visibleCardsLimit - 1);
    final scale = widget.isExpanded
        ? 1.0
        : (1.0 - (effectiveIndex * widget.theme.depthScaleFactor));
    final offsetY = widget.isExpanded
        ? (effectiveIndex * 68.0) * (widget.position.isTop ? 1.0 : -1.0)
        : (effectiveIndex * widget.theme.depthOffsetFactor) *
            (widget.position.isTop ? 1.0 : -1.0);
    final opacity = widget.isExpanded
        ? 1.0
        : (effectiveIndex >= widget.theme.visibleCardsLimit
            ? 0.0
            : (1.0 - effectiveIndex * 0.15));

    final hasIcon =
        widget.toast.icon != null || widget.toast.type != SonnerType.normal;
    final accentColor = _getAccentColor();

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutBack,
      bottom: widget.position.isBottom ? 0 : null,
      top: widget.position.isTop ? 0 : null,
      left: 0,
      right: 0,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 250),
        opacity: opacity.clamp(0.0, 1.0),
        child: Transform.translate(
          offset: Offset(0, offsetY),
          child: Transform.scale(
            scale: scale,
            alignment: widget.position.isTop
                ? Alignment.topCenter
                : Alignment.bottomCenter,
            child: Dismissible(
              key: Key(widget.toast.id),
              direction: widget.toast.dismissible
                  ? DismissDirection.horizontal
                  : DismissDirection.none,
              onDismissed: (_) {
                Sonner.dismiss(widget.toast.id);
                widget.onDismiss?.call();
              },
              child: InkWell(
                onTap: widget.toast.onTap,
                borderRadius: BorderRadius.circular(widget.theme.borderRadius),
                child: Container(
                  width: widget.theme.width,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: widget.theme.backgroundColor,
                    borderRadius:
                        BorderRadius.circular(widget.theme.borderRadius),
                    border:
                        Border.all(color: widget.theme.borderColor, width: 1.0),
                    boxShadow: [
                      BoxShadow(
                        color: widget.theme.shadowColor,
                        blurRadius: widget.theme.elevation * 1.5,
                        offset: Offset(0, widget.theme.elevation * 0.4),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Optional Left-Accent Bar
                      if (widget.toast.style == SonnerStyle.leftAccent)
                        Positioned(
                          left: 0,
                          top: 0,
                          bottom: 0,
                          width: 4.0,
                          child: Container(color: accentColor),
                        ),

                      // Card Content
                      Padding(
                        padding: widget.toast.style == SonnerStyle.leftAccent
                            ? widget.theme.padding
                                .add(const EdgeInsets.only(left: 4.0))
                            : widget.theme.padding,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (hasIcon) ...[
                              _buildTypeIcon(),
                              const SizedBox(width: 12.0),
                            ],
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.toast.title,
                                    style: TextStyle(
                                      color: widget.theme.textColor,
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: widget.theme.fontFamily,
                                    ),
                                  ),
                                  if (widget.toast.description != null) ...[
                                    const SizedBox(height: 3.0),
                                    Text(
                                      widget.toast.description!,
                                      style: TextStyle(
                                        color: widget.theme.descriptionColor,
                                        fontSize: 12.0,
                                        height: 1.35,
                                        fontFamily: widget.theme.fontFamily,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            if (widget.toast.cancelAction != null) ...[
                              const SizedBox(width: 8.0),
                              InkWell(
                                onTap: () {
                                  widget.toast.cancelAction!.onPressed();
                                  Sonner.dismiss(widget.toast.id);
                                },
                                borderRadius: BorderRadius.circular(6.0),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 4.0),
                                  child: Text(
                                    widget.toast.cancelAction!.label,
                                    style: TextStyle(
                                      color: widget.theme.descriptionColor,
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: widget.theme.fontFamily,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                            if (widget.toast.action != null) ...[
                              const SizedBox(width: 10.0),
                              InkWell(
                                onTap: () {
                                  widget.toast.action!.onPressed();
                                  Sonner.dismiss(widget.toast.id);
                                },
                                borderRadius: BorderRadius.circular(6.0),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 5.0),
                                  decoration: BoxDecoration(
                                    color: widget.theme.actionBackgroundColor,
                                    borderRadius: BorderRadius.circular(6.0),
                                  ),
                                  child: Text(
                                    widget.toast.action!.label,
                                    style: TextStyle(
                                      color: widget.theme.actionTextColor,
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: widget.theme.fontFamily,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                            if (widget.toast.closeButton) ...[
                              const SizedBox(width: 6.0),
                              InkWell(
                                onTap: () => Sonner.dismiss(widget.toast.id),
                                borderRadius: BorderRadius.circular(4.0),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Icon(
                                    Icons.close_rounded,
                                    size: 15.0,
                                    color: widget.theme.closeButtonColor,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),

                      // Bottom Progress Countdown Bar
                      if (_progressController != null && widget.depthIndex == 0)
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          height: 2.5,
                          child: AnimatedBuilder(
                            animation: _progressController!,
                            builder: (context, _) {
                              return FractionallySizedBox(
                                alignment: Alignment.centerLeft,
                                widthFactor: (1.0 - _progressController!.value)
                                    .clamp(0.0, 1.0),
                                child: Container(
                                  color: accentColor.withValues(alpha: 0.65),
                                ),
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
