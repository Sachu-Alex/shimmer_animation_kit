import 'package:flutter/material.dart';
import 'package:shimmer_animation_kit/shimmer_animation_kit.dart';

class ThemeDemo extends StatefulWidget {
  const ThemeDemo({super.key});

  @override
  State<ThemeDemo> createState() => _ThemeDemoState();
}

class _ThemeDemoState extends State<ThemeDemo> {
  ShimmerDirection _direction = ShimmerDirection.leftToRight;
  Color _baseColor = const Color(0xFFE0E0E0);
  Color _highlightColor = const Color(0xFFF5F5F5);

  static const _presetBases = [
    Color(0xFFE0E0E0),
    Color(0xFF2C2C2C),
    Color(0xFFCFD8DC),
    Color(0xFFD7CCC8),
    Color(0xFFE8F5E9),
  ];

  static const _presetHighlights = [
    Color(0xFFF5F5F5),
    Color(0xFF3D3D3D),
    Color(0xFFECEFF1),
    Color(0xFFEFEBE9),
    Color(0xFFF1F8E9),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Theme Demo')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Direction picker
          const Text('Direction', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          DropdownButton<ShimmerDirection>(
            value: _direction,
            isExpanded: true,
            items: ShimmerDirection.values
                .map(
                  (d) => DropdownMenuItem(
                    value: d,
                    child: Text(d.name),
                  ),
                )
                .toList(),
            onChanged: (d) => setState(() => _direction = d!),
          ),
          const SizedBox(height: 20),

          // Base color
          const Text('Base Color', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          _ColorRow(
            colors: _presetBases,
            selected: _baseColor,
            onTap: (c) => setState(() => _baseColor = c),
          ),
          const SizedBox(height: 20),

          // Highlight color
          const Text(
            'Highlight Color',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          _ColorRow(
            colors: _presetHighlights,
            selected: _highlightColor,
            onTap: (c) => setState(() => _highlightColor = c),
          ),
          const SizedBox(height: 32),

          // Live preview
          const Text(
            'Live Preview',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ShimmerScope(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerBox(
                  width: 280,
                  height: 20,
                  borderRadius: BorderRadius.circular(4),
                  baseColor: _baseColor,
                  highlightColor: _highlightColor,
                  direction: _direction,
                ),
                const SizedBox(height: 16),
                ShimmerTextWidget(
                  lines: 3,
                  width: 280,
                  baseColor: _baseColor,
                  highlightColor: _highlightColor,
                  direction: _direction,
                ),
                const SizedBox(height: 16),
                ShimmerCircleWidget(
                  diameter: 60,
                  baseColor: _baseColor,
                  highlightColor: _highlightColor,
                  direction: _direction,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ColorRow extends StatelessWidget {
  const _ColorRow({
    required this.colors,
    required this.selected,
    required this.onTap,
  });

  final List<Color> colors;
  final Color selected;
  final void Function(Color) onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: colors.map((c) {
        final isSelected = c.toARGB32() == selected.toARGB32();
        return GestureDetector(
          onTap: () => onTap(c),
          child: Container(
            margin: const EdgeInsets.only(right: 8),
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: c,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? Colors.blue : Colors.grey.shade400,
                width: isSelected ? 3 : 1,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
