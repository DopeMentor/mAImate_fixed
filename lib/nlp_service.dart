import 'dart:convert';
import 'package:cloud_functions/cloud_functions.dart';

class NLPService {
  final HttpsCallable _callable =
      FirebaseFunctions.instance.httpsCallable('api');

  Future<Map<String, dynamic>> analyzeMessage(String message) async {
    try {
      final result = await _callable.call({'message': message});
      return Map<String, dynamic>.from(result.data);
    } catch (e) {
      return {
        'intent': 'error',
        'reply': 'En pystynyt tulkitsemaan viestiäsi kunnolla.',
        'entities': {},
      };
    }
  }
}

