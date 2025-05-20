import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/event_model.dart';

class CalendarService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveEvent(CalendarEvent event) async {
    await _firestore.collection('calendarEvents').doc(event.id).set(event.toMap());
  }

  Future<List<CalendarEvent>> fetchEvents() async {
    final snapshot = await _firestore.collection('calendarEvents').get();
    return snapshot.docs.map((doc) => CalendarEvent.fromMap(doc.data())).toList();
  }

  Future<void> addEvent(Map<String, dynamic> entities) async {
    final id = const Uuid().v4();
    final title = entities['title'] ?? 'Tapahtuma';
    final location = entities['location'];
    final date = entities['date'];
    final time = entities['time'];

    DateTime? startTime;
    if (date != null && time != null) {
      startTime = DateTime.tryParse('$dateT$time');
    } else if (date != null) {
      startTime = DateTime.tryParse(date);
    }

    final event = CalendarEvent(
      id: id,
      title: title,
      startTime: startTime ?? DateTime.now(),
      location: location,
    );

    await saveEvent(event);
  }
}

