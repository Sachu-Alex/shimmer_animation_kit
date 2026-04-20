import 'package:flutter/material.dart';
import 'package:shimmer_animation_kit/shimmer_animation_kit.dart';

import 'screens/auto_detect_demo.dart';
import 'screens/manual_demo.dart';
import 'screens/theme_demo.dart';

void main() => runApp(const ShimmerExampleApp());

class ShimmerExampleApp extends StatelessWidget {
  const ShimmerExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'shimmer_animation_kit demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
        extensions: const [ShimmerTheme.light],
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        brightness: Brightness.dark,
        useMaterial3: true,
        extensions: const [ShimmerTheme.dark],
      ),
      home: const _RootNav(),
    );
  }
}

class _RootNav extends StatefulWidget {
  const _RootNav();

  @override
  State<_RootNav> createState() => _RootNavState();
}

class _RootNavState extends State<_RootNav> {
  int _index = 0;

  static const _screens = [
    AutoDetectDemo(),
    ManualDemo(),
    ThemeDemo(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.auto_fix_high),
            label: 'Auto Detect',
          ),
          NavigationDestination(
            icon: Icon(Icons.widgets_outlined),
            label: 'Manual',
          ),
          NavigationDestination(
            icon: Icon(Icons.palette_outlined),
            label: 'Theme',
          ),
        ],
      ),
    );
  }
}
