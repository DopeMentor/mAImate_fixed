import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechService {
  final SpeechToText _speech = SpeechToText();
  bool _available = false;

  Future<bool> initialize() async {
    final micStatus = await Permission.microphone.request();
    if (micStatus != PermissionStatus.granted) {
      print("❌ Mikrofoni ei sallittu");
      return false;
    }

    _available = await _speech.initialize(
      onStatus: (status) => print("🎙️ Status: $status"),
      onError: (error) => print("❌ Virhe: ${error.errorMsg}"),
    );

    print("🎤 Mikrofoni valmis: $_available");
    return _available;
  }

  void listen(Function(String) onResult) {
    if (_available) {
      _speech.listen(
        onResult: (result) => onResult(result.recognizedWords),
        listenMode: ListenMode.confirmation,
        listenFor: const Duration(seconds: 15),
        pauseFor: const Duration(seconds: 5),
        localeId: 'fi_FI', // Suomi
        cancelOnError: true,
      );
    }
  }

  void stop() {
    if (_available) {
      _speech.stop();
    }
  }

  bool get isListening => _speech.isListening;
}

