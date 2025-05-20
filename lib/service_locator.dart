import 'package:get_it/get_it.dart';
import 'agent_service.dart';
import 'memory_service.dart';
import 'calendar_service.dart';
import 'email_service.dart';
import 'nlp_service.dart';
import 'speech_service.dart';

final locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton<MemoryService>(() => MemoryService());
  locator.registerLazySingleton<CalendarService>(() => CalendarService());
  locator.registerLazySingleton<EmailService>(() => EmailService());
  locator.registerLazySingleton<NLPService>(() => NLPService());
  locator.registerLazySingleton<SpeechService>(() => SpeechService());

  locator.registerLazySingleton<AgentService>(
    () => AgentService(
      locator<MemoryService>(),
      locator<CalendarService>(),
      locator<EmailService>(),
      locator<NLPService>(),
    ),
  );
}

