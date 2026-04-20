## 0.2.0

**Breaking behavior change** — `ShimmerScope` now applies a `ShaderMask` over
its entire child subtree, just like the popular `shimmer` package. This makes
the gradient flow across every widget in the skeleton layout simultaneously
with a single paint operation and zero per-widget rebuild cost.

* **`ShimmerScope`** — applies `ShaderMask(BlendMode.srcATop)` over its child
  subtree. Place skeleton content (white-filled boxes) inside it; real content
  should be outside.
* **`ShimmerKit`** — new `skeleton` parameter. When provided and
  `isLoading: true`, wraps the skeleton in a `ShimmerScope` automatically.
  Omitting `skeleton` falls back to the previous auto-detect mode.
* **`ShimmerBox`, `ShimmerCircleWidget`, `ShimmerTextWidget`** — now render
  solid white containers inside a `ShimmerScope` (the parent `ShaderMask`
  handles the gradient). When used standalone they render a static base-color
  placeholder. This removes per-frame rebuilds inside a scope.
* **`ShimmerScope.hasScope(context)`** — new helper that checks for a scope
  ancestor without registering a rebuild dependency.
* **`ShimmerList`** — skips double-wrapping when already inside a scope.

### Migration

Before (auto-detect, often incomplete on complex screens):
```dart
ShimmerScope(
  child: ShimmerKit(isLoading: _loading, child: MyScreen()),
)
```

After (explicit skeleton, full coverage):
```dart
ShimmerKit(
  isLoading: _loading,
  skeleton: Column(children: [
    ShimmerBox(width: double.infinity, height: 180),
    ShimmerTextWidget(lines: 3, width: 240),
  ]),
  child: MyScreen(),
)
```

## 0.1.1

* **Fix:** `ShimmerScope.of()` no longer throws an assertion error when no
  `ShimmerScope` ancestor is present. It now returns `0.5` as a safe fallback,
  so manual widgets (`ShimmerBox`, `ShimmerCircleWidget`, etc.) can be used
  without a scope — they will display a static shimmer instead of animating.
* Added `ShimmerScope.maybeOf(context)` → `double?` for callers that want to
  distinguish "scope present" from "no scope".

## 0.1.0

* Initial release.
* `ShimmerKit` — auto shape detection via widget tree walking.
* `ShimmerScope` — shared `AnimationController` for synchronized shimmer across the widget tree.
* Manual widgets: `ShimmerBox`, `ShimmerCircleWidget`, `ShimmerTextWidget`, `ShimmerList`.
* `ShimmerTheme` — `ThemeExtension` with light and dark defaults.
* `ShimmerDirection` — 5 gradient directions: `leftToRight`, `rightToLeft`, `topToBottom`, `bottomToTop`, `diagonal`.
* Accessibility: respects `MediaQuery.disableAnimations`, exposes `Semantics(label: 'Loading')`.
* Zero external dependencies.
* Supports Android, iOS, Web, macOS, Windows, Linux.
