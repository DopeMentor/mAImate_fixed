import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/firebase_service.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({super.key});

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final TextEditingController _titleController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  bool _isSaving = false;

  Future<void> _saveEvent() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) return;

    setState(() => _isSaving = true);

    try {
      final firebaseService = Provider.of<FirebaseService>(context, listen: false);
      await firebaseService.addCalendarEvent(title: title, date: _selectedDate);
      Navigator.pop(context); // Palaa kalenteriin
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tapahtuman tallennus epäonnistui.')),
      );
    } finally {
      setState(() => _isSaving = false);
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lisää tapahtuma')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Tapahtuman nimi'),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text(
                  'Päivämäärä: ${_selectedDate.day}.${_selectedDate.month}.${_selectedDate.year}',
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _pickDate,
                  child: const Text('Valitse päivämäärä'),
                ),
              ],
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              icon: const Icon(Icons.save),
              label: const Text('Tallenna tapahtuma'),
              onPressed: _isSaving ? null : _saveEvent,
            ),
          ],
        ),
      ),
    );
  }
}

