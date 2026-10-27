import 'package:flutter/material.dart';
import '../controllers/sonner_controller.dart';
import '../models/sonner_data.dart';
import '../theme/sonner_theme.dart';

/// Animated card displaying a single Sonner toast with card-depth stacking,
/// spring transitions, action buttons, and horizontal swipe-to-dismiss.
class SonnerToastCard extends StatelessWidget {
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

  Widget _buildTypeIcon() {
    if (toast.icon != null) return toast.icon!;

    switch (toast.type) {
      case SonnerType.success:
        return Icon(Icons.check_circle_rounded,
            color: theme.successColor, size: 20);
      case SonnerType.error:
        return Icon(Icons.error_rounded, color: theme.errorColor, size: 20);
      case SonnerType.warning:
        return Icon(Icons.warning_amber_rounded,
            color: theme.warningColor, size: 20);
      case SonnerType.info:
        return Icon(Icons.info_rounded, color: theme.infoColor, size: 20);
      case SonnerType.loading:
        return SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2.0,
            valueColor: AlwaysStoppedAnimation<Color>(theme.textColor),
          ),
        );
      case SonnerType.normal:
      case SonnerType.custom:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (toast.customWidget != null) {
      return toast.customWidget!;
    }

    // Depth calculation
    final effectiveIndex = depthIndex.clamp(0, theme.visibleCardsLimit - 1);
    final scale =
        isExpanded ? 1.0 : (1.0 - (effectiveIndex * theme.depthScaleFactor));
    final offsetY = isExpanded
        ? (effectiveIndex * 64.0) * (position.isTop ? 1.0 : -1.0)
        : (effectiveIndex * theme.depthOffsetFactor) *
            (position.isTop ? 1.0 : -1.0);
    final opacity = isExpanded
        ? 1.0
        : (effectiveIndex >= theme.visibleCardsLimit
            ? 0.0
            : (1.0 - effectiveIndex * 0.15));

    final hasIcon = toast.icon != null || toast.type != SonnerType.normal;

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutBack,
      bottom: position.isBottom ? 0 : null,
      top: position.isTop ? 0 : null,
      left: 0,
      right: 0,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 250),
        opacity: opacity.clamp(0.0, 1.0),
        child: Transform.translate(
          offset: Offset(0, offsetY),
          child: Transform.scale(
            scale: scale,
            alignment:
                position.isTop ? Alignment.topCenter : Alignment.bottomCenter,
            child: Dismissible(
              key: Key(toast.id),
              direction: toast.dismissible
                  ? DismissDirection.horizontal
                  : DismissDirection.none,
              onDismissed: (_) {
                Sonner.dismiss(toast.id);
                onDismiss?.call();
              },
              child: Container(
                width: theme.width,
                padding: theme.padding,
                decoration: BoxDecoration(
                  color: theme.backgroundColor,
                  borderRadius: BorderRadius.circular(theme.borderRadius),
                  border: Border.all(color: theme.borderColor, width: 1.0),
                  boxShadow: [
                    BoxShadow(
                      color: theme.shadowColor,
                      blurRadius: theme.elevation * 1.5,
                      offset: Offset(0, theme.elevation * 0.4),
                    ),
                  ],
                ),
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
                            toast.title,
                            style: TextStyle(
                              color: theme.textColor,
                              fontSize: 13.5,
                              fontWeight: FontWeight.w600,
                              fontFamily: theme.fontFamily,
                            ),
                          ),
                          if (toast.description != null) ...[
                            const SizedBox(height: 3.0),
                            Text(
                              toast.description!,
                              style: TextStyle(
                                color: theme.descriptionColor,
                                fontSize: 12.0,
                                height: 1.35,
                                fontFamily: theme.fontFamily,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (toast.action != null) ...[
                      const SizedBox(width: 10.0),
                      InkWell(
                        onTap: () {
                          toast.action!.onPressed();
                          Sonner.dismiss(toast.id);
                        },
                        borderRadius: BorderRadius.circular(6.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 5.0),
                          decoration: BoxDecoration(
                            color: theme.actionBackgroundColor,
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          child: Text(
                            toast.action!.label,
                            style: TextStyle(
                              color: theme.actionTextColor,
                              fontSize: 12.0,
                              fontWeight: FontWeight.w600,
                              fontFamily: theme.fontFamily,
                            ),
                          ),
                        ),
                      ),
                    ],
                    if (toast.closeButton) ...[
                      const SizedBox(width: 6.0),
                      InkWell(
                        onTap: () => Sonner.dismiss(toast.id),
                        borderRadius: BorderRadius.circular(4.0),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Icon(
                            Icons.close_rounded,
                            size: 15.0,
                            color: theme.closeButtonColor,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
