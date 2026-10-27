# flutter_sonner

<p align="center">
  <a href="https://pub.dev/packages/flutter_sonner"><img src="https://img.shields.io/pub/v/flutter_sonner.svg?style=flat-square&color=blue" alt="Pub Version"></a>
  <a href="https://pub.dev/packages/flutter_sonner/score"><img src="https://img.shields.io/pub/points/flutter_sonner?style=flat-square&color=2E8B57&label=pub%20points" alt="Pub Points"></a>
  <a href="https://govindtank.github.io/flutter_sonner/"><img src="https://img.shields.io/badge/Live%20Demo-Try%20In%20Browser-00ff88?style=flat-square&logo=flutter" alt="Live Demo"></a>
  <a href="https://pub.dev/packages/flutter_sonner"><img src="https://img.shields.io/pub/likes/flutter_sonner?style=flat-square" alt="Pub Likes"></a>
  <a href="https://github.com/govindtank/flutter_sonner/actions"><img src="https://github.com/govindtank/flutter_sonner/actions/workflows/ci.yml/badge.svg" alt="CI"></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/license-Apache%202.0-blue.svg?style=flat-square" alt="License"></a>
</p>

An opinionated, elegant stacked action toast and notification HUD for Flutter, inspired by Emil Kowalski's [Sonner](https://sonner.emilkowal.ski/). Built with **card-depth stacking, spring physics, interactive action buttons, promise-based async toasts, and horizontal swipe-to-dismiss gestures**.

---

## ⚡ Why `flutter_sonner`?

Standard notifications in Flutter often fall short of modern UX expectations:

* 🚫 **Clunky SnackBars**: Push floating action buttons (FABs), cover bottom navigation bars, and lack clean depth stacking when multiple alerts trigger simultaneously.
* 🚫 **Rigid Native Toasts**: OS-native toasts (like Android `Toast`) cannot host interactive buttons ("Undo", "Retry", "View"), have fixed styling, and lack dismiss gestures.
* 🚫 **No Async Promise Binding**: Tracking the lifecycle of an upload, network mutation, or checkout usually requires writing complex boilerplate to swap loading dialogs with success banners.

`flutter_sonner` delivers an ultra-smooth, lightweight, pure Flutter overlay system with stacked card depth.

---

## 🚀 Features

| Feature | Description |
|---|---|
| **🃏 Card-Depth Stacking** | Earlier notifications peek smoothly behind the active front card with spring-scaled depth (0.95x, 0.90x) and elevation drop shadows. |
| **✨ Expand on Hover / Long Press** | Hovering mouse or holding on mobile gracefully unfolds the stack into a full scrollable column. |
| **⚡ Interactive Action Buttons** | Embed pill buttons (`Undo`, `Retry`, `View`) with instant tap dispatch. |
| **🔄 Seamless Promise Toasts** | `Sonner.promise(...)` automatically handles `loading` spinner ➔ in-place transition to `success` or `error`. |
| **👉 Natural Swipe to Dismiss** | Swipe left or right with velocity-aware dismiss physics and smooth opacity fade. |
| **📍 Multi-Position Anchors** | `bottomRight`, `bottomCenter`, `bottomLeft`, `topRight`, `topCenter`, `topLeft`. |
| **🎨 3 Design Presets** | `SonnerTheme.dark()` (Obsidian slate), `SonnerTheme.light()`, and `SonnerTheme.glass()` (frosted glassmorphic). |
| **🌐 Multi-Platform** | 100% pure Dart & Flutter with zero native dependencies. Works on iOS, Android, Web, macOS, Windows, and Linux. |

---

## 📦 Installation

Add `flutter_sonner` to your `pubspec.yaml`:

```bash
flutter pub add flutter_sonner
```

---

## 💡 Quick Start

### 1. Mount `SonnerToaster` globally

Wrap your root `MaterialApp.builder`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_sonner/flutter_sonner.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      builder: (context, child) {
        return SonnerToaster(
          position: SonnerPosition.bottomRight,
          child: child,
        );
      },
      home: const HomeScreen(),
    );
  }
}
```

### 2. Trigger Toasts anywhere without BuildContext!

```dart
// Success with description
Sonner.success(
  'Event created in calendar',
  description: 'Monday, October 27 at 10:30 AM',
);

// Interactive Action (Undo / Retry)
Sonner.show(
  'File moved to trash',
  description: 'Can be restored within 30 days',
  action: SonnerAction(
    label: 'Undo',
    onPressed: () => print('Restored!'),
  ),
);

// Error alert
Sonner.error(
  'Connection timed out',
  description: 'Could not reach database cluster.',
  action: SonnerAction(label: 'Retry', onPressed: () => retry()),
);
```

---

## 🔄 Async Promise Toasts

Eliminate boilerplate when tracking asynchronous workflows:

```dart
await Sonner.promise<UserProfile>(
  api.updateProfile(data),
  loading: 'Updating user profile...',
  success: (profile) => 'Profile saved for ${profile.name}',
  successDescription: (profile) => 'All changes synced with cloud',
  error: (err) => 'Failed to save changes: $err',
);
```

---

## 📍 Positioning & Theming

```dart
SonnerToaster(
  position: SonnerPosition.topCenter,
  theme: SonnerTheme.glass(), // Frosted glassmorphism
  expandByDefault: false,      // Hover or tap to expand
  child: child,
)
```

Available Presets:
* `SonnerTheme.dark()`: Modern dark slate with high-contrast text.
* `SonnerTheme.light()`: Clean paper-white design with crisp border lines.
* `SonnerTheme.glass()`: Translucent frosted glass effect.

---

## 🔗 Related Packages by Author

* **[ai_stream_bubble](https://pub.dev/packages/ai_stream_bubble)** — High-performance streaming AI message bubble with DeepSeek/Claude reasoning accordions.
* **[ai_voice_orb](https://pub.dev/packages/ai_voice_orb)** — Fluid neural voice orb for Conversational AI & voice agents.
* **[spatial_card](https://pub.dev/packages/spatial_card)** — 3D tactile interactive cards & multi-plane parallax surfaces.
* **[waveform_pro](https://pub.dev/packages/waveform_pro)** — GPU-accelerated audio waveform scrubbing & peak visualizer.

---

## 💖 Support the Project

If you find this project useful, consider supporting its active maintenance and future development:

<p align="left">
  <a href="https://buymeacoffee.com/govindtanko"><img src="https://img.shields.io/badge/Buy%20Me%20A%20Coffee-FFDD00?style=for-the-badge&logo=buy-me-a-coffee&logoColor=black" alt="Buy Me A Coffee" /></a>
  <a href="https://github.com/sponsors/govindtank"><img src="https://img.shields.io/badge/GitHub%20Sponsors-EA4AAA?style=for-the-badge&logo=github&logoColor=white" alt="GitHub Sponsors" /></a>
  <a href="https://www.patreon.com/govindtank"><img src="https://img.shields.io/badge/Patreon-F96854?style=for-the-badge&logo=patreon&logoColor=white" alt="Patreon" /></a>
</p>

---

## 📄 License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.

*Maintained with ❤️ by [Govind Tank](https://github.com/govindtank).*
