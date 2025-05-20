import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class ChatMessage {
  final String text;
  final bool isUser;
  final bool isConfirmation;

  ChatMessage({required this.text, required this.isUser, this.isConfirmation = false});
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];
  bool _isListening = false;
  Map<String, dynamic>? _lastIntentData;

  void _sendMessage({bool confirmed = false}) async {
    final text = confirmed ? "Kyllä, lisää tapahtuma" : _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(text: text, isUser: true));
    });
    _controller.clear();

    final uri = Uri.parse("https://us-central1-maimate-7cc71.cloudfunctions.net/nlp");

    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "message": text,
          "userId": "demoUser",
          "confirmed": confirmed,
        }),
      );

      final data = jsonDecode(response.body);
      final reply = data["reply"] ?? "Virhe palvelussa.";
      final needsConfirmation = data["needsConfirmation"] == true;

      setState(() {
        _messages.add(ChatMessage(
          text: reply,
          isUser: false,
          isConfirmation: needsConfirmation,
        ));
        _lastIntentData = needsConfirmation ? data : null;
      });
    } catch (e) {
      setState(() {
        _messages.add(ChatMessage(
          text: "Yhteysvirhe: $e",
          isUser: false,
        ));
      });
    }
  }

  void _toggleListening() {
    setState(() {
      _isListening = !_isListening;
    });
  }

  Widget _buildConfirmationButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton.icon(
            icon: const Icon(Icons.check, size: 18),
            label: const Text("Kyllä"),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2AA876),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
            onPressed: () => _sendMessage(confirmed: true),
          ),
          const SizedBox(width: 16),
          ElevatedButton.icon(
            icon: const Icon(Icons.close, size: 18),
            label: const Text("Ei"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[300],
              foregroundColor: Colors.grey[800],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
            onPressed: () {
              setState(() {
                _messages.add(ChatMessage(
                  text: "Peruutettu.",
                  isUser: false,
                ));
                _lastIntentData = null;
              });
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FC),
      appBar: AppBar(
        title: const Text('mAImate Chat'),
        centerTitle: true,
        backgroundColor: const Color(0xFF0367A6),
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(16),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFE6F2FF),
                    Color(0xFFF5F9FC),
                  ],
                ),
              ),
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  return Column(
                    children: [
                      Align(
                        alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.8,
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: msg.isUser
                                ? const Color(0xFF0367A6)
                                : const Color(0xFF2AA876),
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(16),
                              topRight: const Radius.circular(16),
                              bottomLeft: Radius.circular(msg.isUser ? 16 : 4),
                              bottomRight: Radius.circular(msg.isUser ? 4 : 16),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            msg.text,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                      if (msg.isConfirmation) _buildConfirmationButtons(),
                    ],
                  );
                },
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _isListening
                          ? const Color(0xFF2AA876).withOpacity(0.2)
                          : Colors.transparent,
                    ),
                    child: IconButton(
                      icon: Icon(
                        _isListening ? Icons.mic_off : Icons.mic,
                        color: _isListening
                            ? const Color(0xFF2AA876)
                            : const Color(0xFF0367A6),
                      ),
                      onPressed: _toggleListening,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Kirjoita tai puhu...',
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: Color(0xFF0367A6)),
                    onPressed: () => _sendMessage(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
