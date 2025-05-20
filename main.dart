import 'package:flutter/material.dart';
import 'routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'mAImate',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
      ),
      routes: appRoutes,
      initialRoute: '/',
    );
  }
}

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
              onPressed: () => Navigator.pushNamed(context, '/price'),
              icon: const Icon(Icons.home),
              label: const Text('Hinta-arvio'),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/memory'),
              icon: const Icon(Icons.memory),
              label: const Text('Muisti'),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/add_event'),
              icon: const Icon(Icons.event),
              label: const Text('Luo tapahtuma'),
            ),
          ],
        ),
      ),
    );
  }
}

