import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../calendar_service.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final CalendarService _calendarService = CalendarService();
  late Future<List<Map<String, dynamic>>> _eventsFuture;

  @override
  void initState() {
    super.initState();
    _eventsFuture = _calendarService.getEvents();
  }

  void _refresh() {
    setState(() {
      _eventsFuture = _calendarService.getEvents();
    });
  }

  void _addEventDialog() {
    final titleController = TextEditingController();
    final locationController = TextEditingController();
    final noteController = TextEditingController();
    DateTime selectedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Lisää tapahtuma'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Otsikko'),
                ),
                TextField(
                  controller: locationController,
                  decoration: const InputDecoration(labelText: 'Sijainti'),
                ),
                TextField(
                  controller: noteController,
                  decoration: const InputDecoration(labelText: 'Muistiinpano'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime.now().subtract(const Duration(days: 1)),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      selectedDate = picked;
                    }
                  },
                  child: const Text('Valitse päivämäärä'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await _calendarService.addEvent(
                  title: titleController.text,
                  location: locationController.text,
                  note: noteController.text,
                  dateTime: selectedDate,
                );
                _refresh();
              },
              child: const Text('Tallenna'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kalenteri'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _eventsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Virhe haettaessa tapahtumia.'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Ei tapahtumia.'));
          }

          final events = snapshot.data!;
          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              final date = DateFormat('dd.MM.yyyy').format(DateTime.parse(event['dateTime']));
              return ListTile(
                title: Text(event['title'] ?? 'Tapahtuma'),
                subtitle: Text('${event['location'] ?? ''} – $date'),
                trailing: event['note'] != null && event['note'].toString().isNotEmpty
                    ? const Icon(Icons.note)
                    : null,
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addEventDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}

