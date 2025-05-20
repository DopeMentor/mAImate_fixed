import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('mAImate')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/chat'),
              icon: const Icon(Icons.chat),
              label: const Text('Chat'),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/memory'),
              icon: const Icon(Icons.memory),
              label: const Text('Muisti'),
            ),
          ],
        ),
      ),
    );
  }
}

