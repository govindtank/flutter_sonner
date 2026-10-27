import 'package:flutter/material.dart';
import '../controllers/sonner_controller.dart';
import '../models/sonner_data.dart';
import '../theme/sonner_theme.dart';
import 'sonner_toast_card.dart';

/// The root viewport container hosting the active Sonner toast stack.
/// Typically wrapped around [child] in [MaterialApp.builder] or atop a [Scaffold].
class SonnerToaster extends StatefulWidget {
  const SonnerToaster({
    super.key,
    this.child,
    this.position = SonnerPosition.bottomRight,
    this.theme,
    this.expandByDefault = false,
  });

  final Widget? child;
  final SonnerPosition position;
  final SonnerTheme? theme;
  final bool expandByDefault;

  @override
  State<SonnerToaster> createState() => _SonnerToasterState();
}

class _SonnerToasterState extends State<SonnerToaster> {
  bool _isHovered = false;

  Alignment _getAlignment() {
    switch (widget.position) {
      case SonnerPosition.topRight:
        return Alignment.topRight;
      case SonnerPosition.topCenter:
        return Alignment.topCenter;
      case SonnerPosition.topLeft:
        return Alignment.topLeft;
      case SonnerPosition.bottomRight:
        return Alignment.bottomRight;
      case SonnerPosition.bottomCenter:
        return Alignment.bottomCenter;
      case SonnerPosition.bottomLeft:
        return Alignment.bottomLeft;
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeTheme = widget.theme ??
        (Theme.of(context).brightness == Brightness.dark
            ? SonnerTheme.dark()
            : SonnerTheme.light());

    final isExpanded = widget.expandByDefault || _isHovered;

    final overlay = ValueListenableBuilder<List<SonnerToast>>(
      valueListenable: Sonner.toasts,
      builder: (context, toasts, _) {
        if (toasts.isEmpty) return const SizedBox.shrink();

        final visibleToasts =
            toasts.take(activeTheme.visibleCardsLimit + 1).toList();

        return SafeArea(
          child: Align(
            alignment: _getAlignment(),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: MouseRegion(
                onEnter: (_) => setState(() => _isHovered = true),
                onExit: (_) => setState(() => _isHovered = false),
                child: SizedBox(
                  width: activeTheme.width,
                  height: isExpanded ? (visibleToasts.length * 76.0) : 100.0,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Render backwards so index 0 is drawn on top (frontmost)
                      for (int i = visibleToasts.length - 1; i >= 0; i--)
                        SonnerToastCard(
                          key: ValueKey(visibleToasts[i].id),
                          toast: visibleToasts[i],
                          theme: activeTheme,
                          depthIndex: i,
                          isExpanded: isExpanded,
                          position: widget.position,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    if (widget.child == null) {
      return overlay;
    }

    return Stack(
      children: [
        widget.child!,
        overlay,
      ],
    );
  }
}
