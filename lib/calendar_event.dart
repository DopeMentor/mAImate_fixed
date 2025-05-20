class CalendarEvent {
  final String id;
  final String title;
  final DateTime startTime;
  final String? location;

  CalendarEvent({
    required this.id,
    required this.title,
    required this.startTime,
    this.location,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'startTime': startTime.toIso8601String(),
        'location': location,
      };

  factory CalendarEvent.fromMap(Map<String, dynamic> map) => CalendarEvent(
        id: map['id'],
        title: map['title'],
        startTime: DateTime.parse(map['startTime']),
        location: map['location'],
      );
}

