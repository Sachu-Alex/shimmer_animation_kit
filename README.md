# shimmer_animation_kit

[![pub.dev](https://img.shields.io/pub/v/shimmer_animation_kit.svg)](https://pub.dev/packages/shimmer_animation_kit)
[![pub points](https://img.shields.io/pub/points/shimmer_animation_kit)](https://pub.dev/packages/shimmer_animation_kit/score)
[![likes](https://img.shields.io/pub/likes/shimmer_animation_kit)](https://pub.dev/packages/shimmer_animation_kit/score)
[![license: MIT](https://img.shields.io/badge/license-MIT-purple.svg)](https://opensource.org/licenses/MIT)
[![platforms](https://img.shields.io/badge/platforms-android%20%7C%20ios%20%7C%20web%20%7C%20macos%20%7C%20windows%20%7C%20linux-blue)](#)

A Flutter package providing shimmer loading animations with **auto shape detection**, synchronized animation scope, manual widgets, theming, and full accessibility support.

---

## Features

- **Auto shape detection** — wrap any widget tree; `ShimmerKit` analyses it and builds a matching skeleton automatically
- **`ShimmerScope` sync** — one `AnimationController` drives every shimmer on screen, zero jank
- **Manual widgets** — `ShimmerBox`, `ShimmerCircleWidget`, `ShimmerTextWidget`, `ShimmerList` for hand-crafted layouts
- **Full theming** — `ShimmerTheme` (`ThemeExtension`) with light/dark defaults and per-widget overrides
- **5 directions** — `leftToRight`, `rightToLeft`, `topToBottom`, `bottomToTop`, `diagonal`
- **Accessibility** — respects `MediaQuery.disableAnimations`, exposes `Semantics(label: 'Loading')`
- **Zero dependencies** — pure Flutter, no third-party packages

---

## Installation

```yaml
dependencies:
  shimmer_animation_kit: ^0.1.0
```

---

## Quick Start

```dart
import 'package:shimmer_animation_kit/shimmer_animation_kit.dart';

// 1. Wrap your screen (or subtree) with ShimmerScope.
// 2. Set isLoading: true while fetching data.

ShimmerScope(
  child: Column(
    children: [
      ShimmerKit(
        isLoading: _isLoading,
        child: ProfileCard(), // real widget shown when loaded
      ),
      ShimmerKit(
        isLoading: _isLoading,
        child: ArticleList(),
      ),
    ],
  ),
)
```

Both shimmers share a single animation controller — they pulse in perfect sync.

---

## Auto-Detect vs Manual

| Use case | Approach |
|---|---|
| Unknown / complex layout | `ShimmerKit(isLoading: true, child: ...)` |
| Precise hand-crafted layout | `ShimmerBox` / `ShimmerCircleWidget` / `ShimmerTextWidget` |

**Auto-detect (ShimmerKit)**
```dart
ShimmerKit(
  isLoading: true,
  child: Row(
    children: [
      CircleAvatar(radius: 24),
      Column(children: [Text('Name'), Text('Bio')]),
    ],
  ),
)
```

**Manual**
```dart
ShimmerScope(
  child: Row(
    children: [
      ShimmerCircleWidget(diameter: 48),
      const SizedBox(width: 12),
      ShimmerTextWidget(lines: 2, width: 140),
    ],
  ),
)
```

---

## API Reference

| Widget / Class | Key Parameters | Description |
|---|---|---|
| `ShimmerScope` | `duration`, `child` | Provides shared `AnimationController` to descendants |
| `ShimmerKit` | `isLoading`, `child`, `baseColor`, `highlightColor`, `direction` | Auto-detects child shapes and renders shimmer skeleton |
| `ShimmerBox` | `width`, `height`, `borderRadius` | Animated rectangle |
| `ShimmerCircleWidget` | `diameter` | Animated circle |
| `ShimmerTextWidget` | `lines`, `lineHeight`, `lineSpacing`, `lastLineWidthFraction`, `width` | Stacked text-line bars |
| `ShimmerList` | `itemCount`, `itemBuilder` | Repeating shimmer rows |
| `ShimmerTheme` | `baseColor`, `highlightColor`, `duration`, `direction` | `ThemeExtension` for app-wide defaults |
| `ShimmerDirection` | — | Enum: `leftToRight`, `rightToLeft`, `topToBottom`, `bottomToTop`, `diagonal` |

---

## ShimmerScope

`ShimmerScope` holds **one** `AnimationController` and shares its value down the tree via an `InheritedWidget`. All descendant shimmer widgets read this single value:

```
ShimmerScope
  └─ AnimationController (repeats forever)
       └─ _ShimmerScopeInherited (InheritedWidget)
            ├─ ShimmerBox  ← reads value
            ├─ ShimmerCircleWidget  ← reads value
            └─ ShimmerKit  ← reads value
```

**Why one controller?**  
Multiple `AnimationController`s would drift out of phase. A shared controller guarantees all shimmers are pixel-identical at every frame, with no extra rebuild cost.

---

## Theming

Register `ShimmerTheme` in your `ThemeData`:

```dart
ThemeData(
  extensions: [
    ShimmerTheme(
      baseColor: Color(0xFFE0E0E0),
      highlightColor: Color(0xFFF5F5F5),
      duration: Duration(milliseconds: 1200),
      direction: ShimmerDirection.diagonal,
    ),
  ],
)
```

**Dark mode** — provide a theme extension in your dark `ThemeData`:

```dart
darkTheme: ThemeData.dark().copyWith(
  extensions: [ShimmerTheme.dark],
),
```

If no `ShimmerTheme` extension is found, the package automatically selects `ShimmerTheme.light` or `ShimmerTheme.dark` based on `Theme.of(context).brightness`.

---

## Accessibility

When the user enables **Reduce Motion** on their device, `MediaQuery.disableAnimations` becomes `true`. `ShimmerScope` detects this, stops the controller, and freezes the shimmer at a neutral mid-point value (`0.5`). The skeleton remains visible but stationary — no flicker, no movement.

Each active shimmer also exposes:

```
Semantics(label: 'Loading', excludeSemantics: true)
```

so screen readers announce the loading state without reading phantom widget text.

---

## Contributing

1. Fork the repo and create a feature branch.
2. Run `flutter test` — all tests must pass.
3. Run `flutter analyze` — zero warnings.
4. Open a pull request with a clear description.

---

## License

[MIT](LICENSE) © 2026 Seqato
