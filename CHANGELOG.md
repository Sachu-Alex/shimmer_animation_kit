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
