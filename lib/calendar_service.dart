import 'package:cloud_firestore/cloud_firestore.dart';
import 'calendar_event.dart';

class CalendarService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addEvent(Map<String, dynamic> entities) async {
    final event = {
      'title': entities['title'] ?? 'Uusi tapahtuma',
      'startTime': entities['startTime'] ?? DateTime.now().toIso8601String(),
      'location': entities['location'] ?? '',
    };

    await _firestore.collection('calendar').add(event);
  }

  Future<List<CalendarEvent>> fetchEvents() async {
    final querySnapshot = await _firestore.collection('calendar').get();

    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      return CalendarEvent(
        id: doc.id,
        title: data['title'] ?? 'Ei otsikkoa',
        startTime: DateTime.tryParse(data['startTime'] ?? '') ?? DateTime.now(),
        location: data['location'],
      );
    }).toList();
  }
}

