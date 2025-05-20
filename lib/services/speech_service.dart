import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechService {
  final SpeechToText _speech = SpeechToText();
  bool _available = false;

  Future<bool> initialize() async {
    final micStatus = await Permission.microphone.request();
    if (micStatus != PermissionStatus.granted) {
      throw Exception("Mikrofonikäyttö estetty. Salli se asetuksista.");
    }

    _available = await _speech.initialize(
      onStatus: (status) => print("🎙️ Status: $status"),
      onError: (error) => print("❌ Virhe: ${error.errorMsg}"),
    );
    return _available;
  }

  void listen({
    required Function(String) onResult,
    Function(String)? onPartialResult,
  }) {
    if (!_available) return;
    
    _speech.listen(
      onResult: (result) {
        if (result.finalResult) {
          onResult(result.recognizedWords);
        } else if (onPartialResult != null) {
          onPartialResult(result.recognizedWords);
        }
      },
      listenMode: ListenMode.confirmation,
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 5),
      localeId: 'fi_FI',
      partialResults: true,
    );
  }

  void stop() => _speech.stop();
  bool get isListening => _speech.isListening;
}
