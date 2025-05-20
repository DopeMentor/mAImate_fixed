import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechService {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool isAvailable = false;
  bool isListening = false;

  Future<void> initSpeech() async {
    isAvailable = await _speech.initialize();
  }

  void startListening(Function(String) onResult) {
    if (!isAvailable || isListening) return;

    _speech.listen(
      onResult: (result) => onResult(result.recognizedWords),
      localeId: 'fi_FI',
    );

    isListening = true;
  }

  void stopListening() {
    if (!isListening) return;

    _speech.stop();
    isListening = false;
  }

  void cancel() {
    _speech.cancel();
    isListening = false;
  }
}

