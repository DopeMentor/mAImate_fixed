import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import '../services/firebase_service.dart';

class MessageAnalysisScreen extends StatefulWidget {
  const MessageAnalysisScreen({super.key});

  @override
  State<MessageAnalysisScreen> createState() => _MessageAnalysisScreenState();
}

class _MessageAnalysisScreenState extends State<MessageAnalysisScreen> {
  final TextEditingController _controller = TextEditingController();
  String? _reply;
  String? _intent;
  Map<String, dynamic>? _entities;
  bool _loading = false;
  bool _showAddOption = false;

  Future<void> _analyzeMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _loading = true;
      _reply = null;
      _intent = null;
      _entities = null;
      _showAddOption = false;
    });

    try {
      final response = await http.post(
        Uri.parse('https://us-central1-maimate-7cc71.cloudfunctions.net/nlp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'text': text}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _reply = data['reply'];
          _intent = data['intent'];
          _entities = data['entities'];
          _showAddOption =
              _intent == 'meeting' && (_entities?['dates']?.isNotEmpty ?? false);
        });
      } else {
        setState(() => _reply = 'Virhe analysoinnissa');
      }
    } catch (e) {
      setState(() => _reply = 'Yhteysvirhe');
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _saveEventFromEntities() async {
    if (_entities == null || !_entities!.containsKey('dates')) return;

    final rawDate = _entities!['dates'][0];
    final rawTime = (_entities!['times']?.isNotEmpty ?? false)
        ? _entities!['times'][0]
        : '12:00';

    final parsed = _parseDateTime(rawDate, rawTime);
    if (parsed != null) {
      final firebaseService =
          Provider.of<FirebaseService>(context, listen: false);
      await firebaseService.addCalendarEvent(
        title: _controller.text,
        date: parsed,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tapahtuma lisätty kalenteriin!')),
      );
    }
  }

  DateTime? _parseDateTime(String dateStr, String timeStr) {
    try {
      final parts = dateStr.split(RegExp(r'[.\-/]'));
      final timeParts = timeStr.split(':');
      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]) - 1;
      final year =
          parts.length > 2 ? int.parse(parts[2]) : DateTime.now().year;
      final hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);
      return DateTime(year, month, day, hour, minute);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Analysoi viesti')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Liitä viesti tähän',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _loading ? null : _analyzeMessage,
              child: _loading
                  ? const CircularProgressIndicator()
                  : const Text('Analysoi'),
            ),
            const SizedBox(height: 16),
            if (_reply != null) ...[
              Text('AI-vastaus: $_reply'),
              const SizedBox(height: 8),
              Text('Intent: $_intent'),
              const SizedBox(height: 4),
              Text('Entities: ${_entities.toString()}'),
              const SizedBox(height: 12),
            ],
            if (_showAddOption)
              ElevatedButton.icon(
                onPressed: _saveEventFromEntities,
                icon: const Icon(Icons.calendar_today),
                label: const Text('Lisää kalenteriin'),
              ),
          ],
        ),
      ),
    );
  }
}

