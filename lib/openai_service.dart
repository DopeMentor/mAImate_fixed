import 'dart:convert';
import 'package:http/http.dart' as http;

class OpenAIService {
  final String _baseUrl = 'https://api-awaeklc3xq-uc.a.run.app/nlp';

  Future<Map<String, dynamic>> classifyAndRespond(String input) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'message': input}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> result = json.decode(response.body);
        return result;
      } else {
        return {
          'intent': 'error',
          'reply': 'Failed to get response from backend. (${response.statusCode})'
        };
      }
    } catch (e) {
      return {
        'intent': 'error',
        'reply': 'Exception: $e'
      };
    }
  }
}

