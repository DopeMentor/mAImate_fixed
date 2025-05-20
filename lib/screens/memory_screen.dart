import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MemoryScreen extends StatelessWidget {
  const MemoryScreen({Key? key}) : super(key: key);

  Future<List<Map<String, dynamic>>> _fetchMemories() async {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? 'default_user';

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('memories')
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Muistot')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchMemories(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Virhe haettaessa muistoja.'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Ei muistoja vielä.'));
          }

          final memories = snapshot.data!;

          return ListView.builder(
            itemCount: memories.length,
            itemBuilder: (context, index) {
              final memory = memories[index];
              final message = memory['message'] ?? '';
              final reply = memory['reply'] ?? '';
              final createdAt = memory['createdAt']?.toDate();

              return ListTile(
                title: Text(message),
                subtitle: Text(reply),
                trailing: createdAt != null
                    ? Text(
                        '${createdAt.day}.${createdAt.month}.${createdAt.year}',
                        style: const TextStyle(fontSize: 12),
                      )
                    : null,
              );
            },
          );
        },
      ),
    );
  }
}

