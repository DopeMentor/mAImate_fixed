import 'package:flutter/material.dart';
import 'package:maimate_mvp/openai_service.dart';
import 'package:flutter_tts/flutter_tts.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  final OpenAIService _openAI = OpenAIService();
  final FlutterTts _flutterTts = FlutterTts();
  bool _isLoading = false;

  @override
  void dispose() {
    _controller.dispose();
    _flutterTts.stop();
    super.dispose();
  }

  Future<void> _speak(String text) async {
    await _flutterTts.setLanguage("fi-FI");
    await _flutterTts.setPitch(1.0);
    await _flutterTts.speak(text);
  }

  Future<void> _handleSend() async {
    final input = _controller.text.trim();
    if (input.isEmpty) return;

    setState(() {
      _messages.add({'role': 'user', 'content': input});
      _controller.clear();
      _isLoading = true;
    });

    try {
      final result = await _openAI.classifyAndRespond(input);
      final reply = result['reply'] ?? 'En saanut vastausta.';

      setState(() {
        _messages.add({'role': 'assistant', 'content': reply});
        _isLoading = false;
      });

      _speak(reply);
    } catch (e) {
      setState(() {
        _messages.add({'role': 'assistant', 'content': 'Virhe: $e'});
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('mAImate Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUser = message['role'] == 'user';
                return ListTile(
                  title: Align(
                    alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isUser ? Colors.blue[100] : Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(message['content'] ?? ''),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(12),
              child: CircularProgressIndicator(),
            ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Kysy mitä vain...',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _isLoading ? null : _handleSend,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

