import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Lisää tapahtuma Firestoreen
  Future<void> addCalendarEvent({
    required String title,
    required DateTime date,
  }) async {
    await _firestore.collection('events').add({
      'title': title,
      'date': Timestamp.fromDate(date),
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  /// Hae kaikki kalenteritapahtumat
  Future<List<Map<String, dynamic>>> getCalendarEvents() async {
    final snapshot = await _firestore.collection('events').get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  /// Tallenna muisti (esim. NLP-agentin analyysi)
  Future<void> saveMemory({
    required String originalText,
    required String intent,
    required Map<String, dynamic> entities,
    required String reply,
  }) async {
    await _firestore.collection('memories').add({
      'text': originalText,
      'intent': intent,
      'entities': entities,
      'reply': reply,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  /// Hae kaikki muistot
  Future<List<Map<String, dynamic>>> getMemories() async {
    final snapshot = await _firestore.collection('memories').orderBy('timestamp', descending: true).get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }
}

