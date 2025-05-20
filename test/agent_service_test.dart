import 'package:flutter_test/flutter_test.dart';
import 'package:maimate_mvp/agent_service.dart';

void main() {
  group('AgentService', () {
    final agent = AgentService();

    test('Returns fallback reply for unknown input', () async {
      final reply = await agent.handleUserMessage("asdfasdfasdfasdf");
      expect(reply.isNotEmpty, true);
    });
  });
}

