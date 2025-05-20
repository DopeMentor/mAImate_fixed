import 'package:flutter/material.dart';
import '../calendar_service.dart';
import '../models/event_model.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final CalendarService _calendarService = CalendarService();
  late Future<List<CalendarEvent>> _events;

  @override
  void initState() {
    super.initState();
    _events = _calendarService.fetchEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tapahtumat')),
      body: FutureBuilder<List<CalendarEvent>>(
        future: _events,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Ei tapahtumia'));
          }

          final events = snapshot.data!;
          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              return ListTile(
                title: Text(event.title),
                subtitle: Text(
                  '${event.startTime.toLocal()} - ${event.location ?? "ei paikkaa"}',
                ),
              );
            },
          );
        },
      ),
    );
  }
}

