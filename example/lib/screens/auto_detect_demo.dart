import 'package:flutter/material.dart';
import 'package:shimmer_animation_kit/shimmer_animation_kit.dart';

class AutoDetectDemo extends StatefulWidget {
  const AutoDetectDemo({super.key});

  @override
  State<AutoDetectDemo> createState() => _AutoDetectDemoState();
}

class _AutoDetectDemoState extends State<AutoDetectDemo> {
  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    return ShimmerScope(
      child: Scaffold(
        appBar: AppBar(title: const Text('Auto Detect')),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Profile card
            ShimmerKit(
              isLoading: _isLoading,
              child: const Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundImage: NetworkImage(
                      'https://i.pravatar.cc/150?img=3',
                    ),
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Jane Doe',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text('Flutter Developer'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // List of items
            ...List.generate(
              5,
              (i) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ShimmerKit(
                  isLoading: _isLoading,
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor:
                            Colors.primaries[i % Colors.primaries.length],
                        child: Text('${i + 1}'),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Item title ${i + 1}',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Subtitle for item ${i + 1}',
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => setState(() => _isLoading = !_isLoading),
          label: Text(_isLoading ? 'Show Content' : 'Show Shimmer'),
          icon: Icon(_isLoading ? Icons.visibility : Icons.hourglass_empty),
        ),
      ),
    );
  }
}
