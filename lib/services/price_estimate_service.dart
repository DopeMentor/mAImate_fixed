import 'dart:convert';
import 'package:http/http.dart' as http;

class PriceEstimateService {
  static const String endpointUrl = 'https://us-central1-maimate-7cc71.cloudfunctions.net/priceEstimate';

  static Future<Map<String, dynamic>> getPriceEstimate({
    required String location,
    required double size,
    required int rooms,
    required bool balcony,
  }) async {
    final response = await http.post(
      Uri.parse(endpointUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'location': location,
        'size': size,
        'rooms': rooms,
        'balcony': balcony,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Virhe haettaessa hinta-arviota: ${response.body}');
    }
  }
}

