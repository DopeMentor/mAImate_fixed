import 'screens/message_analysis_screen.dart';
import 'screens/memory_screen.dart';
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/calendar_screen.dart';
import 'screens/add_event_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String chat = '/chat';
  static const String calendar = '/calendar';
  static const String addEvent = '/add_event';
  static const String memory = '/memory';
  static const String messageAnalysis = '/message_analysis';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case chat:
        return MaterialPageRoute(builder: (_) => const ChatScreen());
      case calendar:
        return MaterialPageRoute(builder: (_) => const CalendarScreen());
      case addEvent:
        return MaterialPageRoute(builder: (_) => 
      const AddEventScreen());case memory:
        return MaterialPageRoute(builder: (_) => const MemoryScreen());
      case messageAnalysis:
        return MaterialPageRoute(builder: (_) => const MessageAnalysisScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('Tuntematon reitti: ${settings.name}')),
          ),
        );
    }
  }
}

