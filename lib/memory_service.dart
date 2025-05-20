import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MemoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _userId = FirebaseAuth.instance.currentUser?.uid ?? 'default_user';

  Future<void> save(String message, String reply, Map<String, dynamic> entities) async {
    await _firestore
        .collection('users')
        .doc(_userId)
        .collection('memories')
        .add({
      'message': message,
      'reply': reply,
      'entities': entities,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}

