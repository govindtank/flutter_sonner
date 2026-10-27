import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sonner/flutter_sonner.dart';

void main() {
  runApp(const FlutterSonnerDemoApp());
}

class FlutterSonnerDemoApp extends StatefulWidget {
  const FlutterSonnerDemoApp({super.key});

  @override
  State<FlutterSonnerDemoApp> createState() => _FlutterSonnerDemoAppState();
}

enum DemoThemeType { dark, light, glass }

class _FlutterSonnerDemoAppState extends State<FlutterSonnerDemoApp> {
  DemoThemeType _selectedTheme = DemoThemeType.dark;
  SonnerPosition _position = SonnerPosition.bottomRight;

  SonnerTheme get _currentSonnerTheme {
    switch (_selectedTheme) {
      case DemoThemeType.dark:
        return SonnerTheme.dark();
      case DemoThemeType.light:
        return SonnerTheme.light();
      case DemoThemeType.glass:
        return SonnerTheme.glass();
    }
  }

  Color get _scaffoldColor {
    switch (_selectedTheme) {
      case DemoThemeType.dark:
        return const Color(0xFF09090B);
      case DemoThemeType.light:
        return const Color(0xFFF4F4F5);
      case DemoThemeType.glass:
        return const Color(0xFF0F172A);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'flutter_sonner — Opinionated Stacked Toast Showcase',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: _selectedTheme == DemoThemeType.light
            ? Brightness.light
            : Brightness.dark,
        scaffoldBackgroundColor: _scaffoldColor,
        useMaterial3: true,
      ),
      builder: (context, child) {
        // Mount SonnerToaster globally
        return SonnerToaster(
          position: _position,
          theme: _currentSonnerTheme,
          child: child,
        );
      },
      home: SonnerDemoScreen(
        selectedTheme: _selectedTheme,
        selectedPosition: _position,
        onThemeChanged: (theme) => setState(() => _selectedTheme = theme),
        onPositionChanged: (pos) => setState(() => _position = pos),
      ),
    );
  }
}

class SonnerDemoScreen extends StatefulWidget {
  const SonnerDemoScreen({
    super.key,
    required this.selectedTheme,
    required this.selectedPosition,
    required this.onThemeChanged,
    required this.onPositionChanged,
  });

  final DemoThemeType selectedTheme;
  final SonnerPosition selectedPosition;
  final ValueChanged<DemoThemeType> onThemeChanged;
  final ValueChanged<SonnerPosition> onPositionChanged;

  @override
  State<SonnerDemoScreen> createState() => _SonnerDemoScreenState();
}

class _SonnerDemoScreenState extends State<SonnerDemoScreen> {
  bool _copiedCommand = false;

  Future<void> _copyPubCommand() async {
    await Clipboard.setData(
      const ClipboardData(text: 'flutter pub add flutter_sonner'),
    );
    HapticFeedback.lightImpact();
    setState(() => _copiedCommand = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _copiedCommand = false);
    });
  }

  void _triggerSuccess() {
    Sonner.success(
      'Event created in calendar',
      description: 'Monday, October 27 at 10:30 AM',
      action: SonnerAction(
        label: 'View',
        onPressed: () => debugPrint('Viewing event...'),
      ),
    );
  }

  void _triggerActionToast() {
    Sonner.show(
      'File moved to trash',
      description: 'Can be restored within 30 days',
      action: SonnerAction(
        label: 'Undo',
        onPressed: () {
          Sonner.info('Restored file back to documents');
        },
      ),
    );
  }

  void _triggerError() {
    Sonner.error(
      'Failed to sync changes',
      description: 'Server returned HTTP 503 Service Unavailable',
      action: SonnerAction(label: 'Retry', onPressed: () => _triggerSuccess()),
    );
  }

  void _triggerPromise() {
    final future = Future.delayed(
      const Duration(milliseconds: 2200),
      () => 'package_bundle.zip',
    );

    Sonner.promise<String>(
      future,
      loading: 'Uploading archive to CDN...',
      success: (fileName) => 'Uploaded $fileName',
      successDescription: (_) => 'SHA-256 integrity checksum verified',
      error: (err) => 'Upload failed: $err',
    );
  }

  void _triggerStackDemo() {
    Sonner.info('Connecting to cluster node #1...');
    Future.delayed(const Duration(milliseconds: 200), () {
      Sonner.warning('High memory utilization detected on pod-03');
    });
    Future.delayed(const Duration(milliseconds: 400), () {
      Sonner.success('Auto-scaling group expanded by +2 replicas');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(
              Icons.layers_rounded,
              color: Color(0xFFFAFAFA),
              size: 20,
            ),
            const SizedBox(width: 8),
            const Text(
              'flutter_sonner',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 6.0,
                vertical: 2.0,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: const Text(
                'v1.0.0',
                style: TextStyle(
                  fontSize: 11.0,
                  fontWeight: FontWeight.w700,
                  color: Colors.white70,
                ),
              ),
            ),
          ],
        ),
        actions: [
          // 1-Tap Copy Install Button
          InkWell(
            onTap: _copyPubCommand,
            borderRadius: BorderRadius.circular(6.0),
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 4.0,
              ),
              decoration: BoxDecoration(
                color: _copiedCommand
                    ? const Color(0xFF10B981).withValues(alpha: 0.2)
                    : Colors.white.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(6.0),
                border: Border.all(
                  color: _copiedCommand
                      ? const Color(0xFF10B981)
                      : Colors.white.withValues(alpha: 0.15),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _copiedCommand ? Icons.check : Icons.terminal_rounded,
                    size: 14,
                    color: _copiedCommand
                        ? const Color(0xFF10B981)
                        : Colors.white70,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _copiedCommand ? 'Copied pub add!' : 'pub add',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _copiedCommand
                          ? const Color(0xFF10B981)
                          : Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 580),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header Hero
                const Text(
                  'An opinionated toast component for Flutter.',
                  style: TextStyle(
                    fontSize: 26.0,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8.0),
                const Text(
                  'Inspired by Emil Kowalski\'s Sonner. Natural card-depth stacking, spring physics, interactive actions, and swipe-to-dismiss.',
                  style: TextStyle(
                    fontSize: 14.5,
                    height: 1.45,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 24.0),

                // Controls Grid
                Card(
                  elevation: 0,
                  color: Theme.of(context).cardColor.withValues(alpha: 0.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    side: BorderSide(
                      color: Colors.white.withValues(alpha: 0.1),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'CONFIGURATION',
                          style: TextStyle(
                            fontSize: 11.0,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.8,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 12.0),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Position',
                                    style: TextStyle(fontSize: 12.5),
                                  ),
                                  const SizedBox(height: 4.0),
                                  DropdownButtonFormField<SonnerPosition>(
                                    initialValue: widget.selectedPosition,
                                    decoration: const InputDecoration(
                                      isDense: true,
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 8,
                                      ),
                                      border: OutlineInputBorder(),
                                    ),
                                    items: SonnerPosition.values.map((pos) {
                                      return DropdownMenuItem(
                                        value: pos,
                                        child: Text(
                                          pos.name,
                                          style: const TextStyle(fontSize: 13),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (pos) {
                                      if (pos != null) {
                                        widget.onPositionChanged(pos);
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Theme Preset',
                                    style: TextStyle(fontSize: 12.5),
                                  ),
                                  const SizedBox(height: 4.0),
                                  DropdownButtonFormField<DemoThemeType>(
                                    initialValue: widget.selectedTheme,
                                    decoration: const InputDecoration(
                                      isDense: true,
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 8,
                                      ),
                                      border: OutlineInputBorder(),
                                    ),
                                    items: const [
                                      DropdownMenuItem(
                                        value: DemoThemeType.dark,
                                        child: Text(
                                          'Dark Obsidian',
                                          style: TextStyle(fontSize: 13),
                                        ),
                                      ),
                                      DropdownMenuItem(
                                        value: DemoThemeType.light,
                                        child: Text(
                                          'Light Clean',
                                          style: TextStyle(fontSize: 13),
                                        ),
                                      ),
                                      DropdownMenuItem(
                                        value: DemoThemeType.glass,
                                        child: Text(
                                          'Glassmorphism',
                                          style: TextStyle(fontSize: 13),
                                        ),
                                      ),
                                    ],
                                    onChanged: (theme) {
                                      if (theme != null) {
                                        widget.onThemeChanged(theme);
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),

                // Toast Trigger Buttons
                const Text(
                  'TRIGGER TOASTS',
                  style: TextStyle(
                    fontSize: 11.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 12.0),
                Wrap(
                  spacing: 10.0,
                  runSpacing: 10.0,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _triggerSuccess,
                      icon: const Icon(
                        Icons.check_circle_outline,
                        color: Color(0xFF10B981),
                        size: 16,
                      ),
                      label: const Text('Success Toast'),
                    ),
                    ElevatedButton.icon(
                      onPressed: _triggerActionToast,
                      icon: const Icon(Icons.undo_rounded, size: 16),
                      label: const Text('Action (Undo)'),
                    ),
                    ElevatedButton.icon(
                      onPressed: _triggerError,
                      icon: const Icon(
                        Icons.error_outline,
                        color: Color(0xFFEF4444),
                        size: 16,
                      ),
                      label: const Text('Error Toast'),
                    ),
                    ElevatedButton.icon(
                      onPressed: _triggerPromise,
                      icon: const Icon(Icons.sync_rounded, size: 16),
                      label: const Text('Promise (Async)'),
                    ),
                    ElevatedButton.icon(
                      onPressed: _triggerStackDemo,
                      icon: const Icon(Icons.layers_outlined, size: 16),
                      label: const Text('Stack 3 Toasts'),
                    ),
                    OutlinedButton.icon(
                      onPressed: () => Sonner.dismissAll(),
                      icon: const Icon(Icons.clear_all, size: 16),
                      label: const Text('Dismiss All'),
                    ),
                  ],
                ),
                const SizedBox(height: 36.0),

                // Interactive Instructions
                Container(
                  padding: const EdgeInsets.all(14.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.04),
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.08),
                    ),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '💡 Pro-Tips for Testing:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13.0,
                        ),
                      ),
                      SizedBox(height: 6.0),
                      Text(
                        '• Click "Stack 3 Toasts" then hover mouse over the cards to watch the depth stack expand into a column.\n'
                        '• Swipe any toast horizontally left or right to dismiss with natural velocity.\n'
                        '• Click "Promise (Async)" to see the loading spinner morph into a verified success toast in-place.',
                        style: TextStyle(
                          fontSize: 12.5,
                          height: 1.45,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
