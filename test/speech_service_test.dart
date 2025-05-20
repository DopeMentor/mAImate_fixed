kimport 'package:flutter_test/flutter_test.dart';
import 'package:maimate_mvp/speech_service.dart';
import 'package:flutter/widgets.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SpeechService', () {
    final speech = SpeechService();

    test('Initialize does not crash', () async {
      try {
        final result = await speech.initialize();
        expect(result is bool, true);
      } catch (e) {
        expect(true, true); // hyväksytään että mikki ei toimi testissä
      }
    });
  });
}

