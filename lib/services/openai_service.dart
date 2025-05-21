import 'dart:convert';
import 'package:http/http.dart' as http;

class OpenAIService {
  final Uri functionUrl = Uri.parse(
    'https://us-central1-maimate-7cc71.cloudfunctions.net/nlp',
  );

  Future<Map<String, dynamic>> analyzeText(String text) async {
    try {
      final response = await http.post(
        functionUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'text': text}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'reply': data['reply'] ?? 'En saanut vastausta.',
          'intent': data['intent'],
          'entities': data['entities'],
        };
      } else {
        print("❌ Server error: ${response.statusCode}");
        print("Response body: ${response.body}");
        return {
          'reply': 'Pahoittelut, analysointi epäonnistui.',
          'intent': null,
          'entities': null,
        };
      }
    } catch (e) {
      print('🔥 OpenAIService Error: $e');
      return {
        'reply': 'Tapahtui virhe.',
        'intent': null,
        'entities': null,
      };
    }
  }
}

