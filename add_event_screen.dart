import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/event_model.dart';
import '../services/calendar_service.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({super.key});

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _participantsController = TextEditingController();
  DateTime? _selectedStartDate;

  final CalendarService _calendarService = CalendarService();

  Future<void> _saveEvent() async {
    if (_formKey.currentState!.validate() && _selectedStartDate != null) {
      final event = CalendarEvent(
        id: const Uuid().v4(),
        title: _titleController.text.trim(),
        startTime: _selectedStartDate!,
        location: _locationController.text.trim(),
        description: _descriptionController.text.trim(),
        participants: _participantsController.text
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList(),
      );

      await _calendarService.saveEvent(event);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tapahtuma tallennettu!')),
      );

      Navigator.pop(context);
    }
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(hours: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (time != null) {
        setState(() {
          _selectedStartDate = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Luo uusi tapahtuma')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Otsikko'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Täytä otsikko' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: 'Paikka'),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Kuvaus'),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _participantsController,
                decoration: const InputDecoration(
                    labelText: 'Osallistujat (pilkuilla eroteltuna)'),
              ),
              const SizedBox(height: 10),
              TextButton.icon(
                onPressed: _pickDateTime,
                icon: const Icon(Icons.calendar_today),
                label: Text(_selectedStartDate == null
                    ? 'Valitse ajankohta'
                    : _selectedStartDate.toString()),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveEvent,
                child: const Text('Tallenna tapahtuma'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

