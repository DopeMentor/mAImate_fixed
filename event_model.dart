class CalendarEvent {
  final String id;
  final String title;
  final DateTime startTime;
  final DateTime? endTime;
  final String? location;
  final String? description;
  final List<String>? participants;

  CalendarEvent({
    required this.id,
    required this.title,
    required this.startTime,
    this.endTime,
    this.location,
    this.description,
    this.participants,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'location': location,
      'description': description,
      'participants': participants,
    };
  }

  factory CalendarEvent.fromMap(Map<String, dynamic> map) {
    return CalendarEvent(
      id: map['id'],
      title: map['title'],
      startTime: DateTime.parse(map['startTime']),
      endTime: map['endTime'] != null ? DateTime.parse(map['endTime']) : null,
      location: map['location'],
      description: map['description'],
      participants: List<String>.from(map['participants'] ?? []),
    );
  }
}

