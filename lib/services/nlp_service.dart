import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class NlpService {
  final logger = Logger();
  final Uri endpoint = Uri.parse('https://api-awaeklc3xq-uc.a.run.app/nlp');

  Future<Map<String, dynamic>> analyzeMessage(String input, String userId,
      {int retries = 2}) async {
    logger.i("🐛 🧠 Sending NLP request: $input");

    try {
      final response = await http
          .post(
            endpoint,
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({"message": input, "userId": userId}),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        logger.i("🐛 📥 Received NLP response: ${response.body}");
        return data;
      } else {
        throw Exception("Server error: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      if (retries > 0) {
        logger.w("⚠️ ⚠️ NLP request failed, retrying... ($retries attempts left): $e");
        return analyzeMessage(input, userId, retries: retries - 1);
      } else {
        logger.e("⛔ ❌ NLP request failed after all retries: $e");
        return {
          "intent": "unknown",
          "entities": {},
          "reply": "En pystynyt tulkitsemaan viestiäsi kunnolla.",
          "context": "",
          "confidence": 0.0,
        };
      }
    }
  }
}

