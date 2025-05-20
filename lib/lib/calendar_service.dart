import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CalendarService {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<void> addEvent({
    required String title,
    required DateTime dateTime,
    String? location,
    String? note,
  }) async {
    final userId = _auth.currentUser?.uid ?? 'default_user';

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('calendar')
        .add({
      'title': title,
      'dateTime': dateTime.toIso8601String(),
      'location': location ?? '',
      'note': note ?? '',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<List<Map<String, dynamic>>> getEvents() async {
    final userId = _auth.currentUser?.uid ?? 'default_user';

    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('calendar')
        .orderBy('dateTime')
        .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }
}

