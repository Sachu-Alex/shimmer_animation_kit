/// A Flutter package providing shimmer loading animations with auto shape
/// detection, synchronized animation scope, manual widgets, theming, and
/// full accessibility support.
library shimmer_animation_kit;

// Core config
export 'src/shimmer_direction.dart' show ShimmerDirection;
export 'src/shimmer_theme.dart' show ShimmerTheme;

// Animation controller scope
export 'src/shimmer_scope.dart' show ShimmerScope;

// Auto-detect widget
export 'src/shimmer_kit.dart' show ShimmerKit;

// Manual widgets
export 'src/widgets/shimmer_box.dart' show ShimmerBox;
export 'src/widgets/shimmer_circle_widget.dart' show ShimmerCircleWidget;
export 'src/widgets/shimmer_text_widget.dart' show ShimmerTextWidget;
export 'src/widgets/shimmer_list.dart' show ShimmerList;

// Shape models (used for custom ShimmerPainter setups)
export 'src/shimmer_shapes.dart'
    show
        ShimmerShape,
        ShimmerRectangle,
        ShimmerCircle,
        ShimmerText,
        ShimmerGroup;
