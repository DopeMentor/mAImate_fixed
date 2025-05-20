import 'dart:convert';
import 'package:http/http.dart' as http;
import 'secrets.dart';

class DeepSeekService {
  static const _apiUrl = 'https://api.deepseek.com/v1/chat/completions';

  Future<String> sendMessage(String message) async {
    final response = await http.post(
      Uri.parse(_apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $deepSeekApiKey',
      },
      body: jsonEncode({
        'model': 'deepseek-chat',
        'messages': [
          {'role': 'user', 'content': message}
        ],
        'max_tokens': 500,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final reply = data['choices'][0]['message']['content'];
      return reply.trim();
    } else {
      print('DeepSeek error: ${response.body}');
      return 'Virhe: DeepSeek ei vastannut 😞';
    }
  }
}
