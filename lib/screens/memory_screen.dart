import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/firebase_service.dart';

class MemoryScreen extends StatefulWidget {
  const MemoryScreen({super.key});

  @override
  State<MemoryScreen> createState() => _MemoryScreenState();
}

class _MemoryScreenState extends State<MemoryScreen> {
  List<Map<String, dynamic>> _memories = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadMemories();
  }

  Future<void> _loadMemories() async {
    final firebaseService = Provider.of<FirebaseService>(context, listen: false);
    final data = await firebaseService.getMemories();
    setState(() {
      _memories = data;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Muisti')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _memories.length,
              itemBuilder: (context, index) {
                final memory = _memories[index];
                final intent = memory['intent'] ?? '-';
                final reply = memory['reply'] ?? '-';
                final text = memory['text'] ?? '-';
                final timestamp = memory['timestamp']?.toDate().toString().substring(0, 16) ?? '';

                return ListTile(
                  title: Text(text),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Intent: $intent'),
                      Text('Vastaus: $reply'),
                      if (timestamp.isNotEmpty) Text('Aika: $timestamp'),
                    ],
                  ),
                  isThreeLine: true,
                );
              },
            ),
    );
  }
}

