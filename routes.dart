import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/memory_screen.dart';
import 'screens/price_estimate_screen.dart';
import 'screens/calendar_screen.dart';
import 'screens/add_event_screen.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => const HomeScreen(),
  '/chat': (context) => const ChatScreen(),
  '/memory': (context) => const MemoryScreen(),
  '/price': (context) => const PriceEstimateScreen(),
  '/calendar': (context) => const CalendarScreen(),
  '/add_event': (context) => const AddEventScreen(),
};

