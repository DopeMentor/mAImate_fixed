import 'package:flutter/material.dart';
import 'speech_service.dart'; // Varmista, että polku on oikein

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  final SpeechService _speech = SpeechService();
  bool _isListening = false;
  String _partialText = '';

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  Future<void> _initSpeech() async {
    try {
      await _speech.initialize();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Virhe: $e")),
      );
    }
  }

  void _toggleListening() {
    if (_isListening) {
      _speech.stop();
      setState(() {
        _isListening = false;
        if (_partialText.isNotEmpty) {
          _controller.text = _partialText;
          _partialText = '';
        }
      });
    } else {
      setState(() => _isListening = true);
      _speech.listen(
        onResult: (text) => _handleSend(text),
        onPartialResult: (text) => setState(() => _partialText = text),
      );
    }
  }

  // ... (_handleSend ja build-metodi säilyvät samana, LISÄÄ ALLA OLEVA WIDGET)
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleListening,
        child: Icon(_isListening ? Icons.mic_off : Icons.mic),
        backgroundColor: _isListening ? Colors.red : Colors.blue,
      ),
      // ... (muut widgetit)
    );
  }
}
