import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:maimate_fixed/services/openai_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = '';
  final FlutterTts _flutterTts = FlutterTts();
  final OpenAIService _openAIService = OpenAIService();

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  void _sendMessage(String message) async {
    setState(() {
      _messages.add({'role': 'user', 'text': message});
      _controller.clear();
    });

    final result = await _openAIService.analyzeText(message);

    final reply = result['reply'] ?? 'Ei vastausta';
    final intent = result['intent'];
    final entities = result['entities'];

    setState(() {
      _messages.add({'role': 'ai', 'text': reply});
    });

    await _flutterTts.speak(reply);

    // 🧠 Debug-printit
    print("INTENT: $intent");
    print("ENTITIES: $entities");
  }

  void _startListening() async {
    bool available = await _speech.initialize();
    if (available) {
      setState(() => _isListening = true);
      _speech.listen(onResult: (val) {
        setState(() {
          _text = val.recognizedWords;
        });
      });
    }
  }

  void _stopListening() async {
    await _speech.stop();
    setState(() => _isListening = false);
    if (_text.isNotEmpty) {
      _sendMessage(_text);
      _text = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Assistant')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isUser = msg['role'] == 'user';
                return ListTile(
                  title: Align(
                    alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isUser ? Colors.indigo.shade100 : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(msg['text'] ?? ''),
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(_isListening ? Icons.mic_off : Icons.mic),
                  onPressed: _isListening ? _stopListening : _startListening,
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(hintText: 'Kirjoita tai puhu...'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    if (_controller.text.trim().isNotEmpty) {
                      _sendMessage(_controller.text.trim());
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

