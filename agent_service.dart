import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'memory_service.dart';
import 'calendar_service.dart';
import 'email_service.dart';
import 'nlp_service.dart';

class AgentService {
  final MemoryService _memory;
  final CalendarService _calendar;
  final EmailService _email;
  final NLPService _nlp;

  AgentService(this._memory, this._calendar, this._email, this._nlp);

  Future<String> handleUserMessage(String message, BuildContext context) async {
    final result = await _nlp.analyzeMessage(message);
    final intent = result['intent'];
    final reply = result['reply'];
    final entities = result['entities'] ?? {};

    if (intent == 'memory') {
      await _memory.save(message, reply, entities);
    } else if (intent == 'calendar') {
      await _calendar.addEvent(entities);
      final title = entities['title'] ?? 'Tapahtuma';
      // Näytä snackbar onnistumisesta
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ Tapahtuma "$title" tallennettu'),
          duration: const Duration(seconds: 3),
        ),
      );
    } else if (intent == 'email') {
      await _email.sendEmail(
        to: 'test@example.com',
        subject: 'AI Mail',
        body: reply,
      );
    } else if (intent == 'price') {
      final callable = FirebaseFunctions.instance.httpsCallable('priceEstimate');
      final result = await callable.call({'input': message});
      return result.data['response'] ?? 'Hinta-arvio ei saatavilla.';
    }

    return reply;
  }
}

