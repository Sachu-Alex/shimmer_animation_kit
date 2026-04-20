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
