
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'routes.dart';
import 'service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  setupLocator(); // <== tämä rivi on tärkeä!
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'mAImate MVP',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',      // 🔥 Määritetty aloitusreitti
      routes: appRoutes,          // 🔥 Käytetään routes.dart-reittejä
    );
  }
}

// 🔽 Tämä on nyt reitillä '/'
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('mAImate'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                FirebaseFirestore.instance.collection('test').add({
                  'message': 'Hello from mAImate!',
                  'timestamp': Timestamp.now(),
                });
              },
              child: const Text('Tallenna testiviesti Firestoreen'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/chat');
              },
              child: const Text('Siirry mAImate-chat'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/price');
              },
              child: const Text('Hae hinta-arvio'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/memory');
              },
              child: const Text('Näytä muistot 🧠'),
            ),
          ],
        ),
      ),
    );
  }
}

