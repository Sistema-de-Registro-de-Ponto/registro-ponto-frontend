import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:registro_ponto_frontend/features/journey/domain/entities/journey.dart';
import 'package:registro_ponto_frontend/features/journey/domain/entities/journey_status.dart';

Future<void> initJourneyHistoryTests() async {
  await initializeDateFormatting('pt_BR');
}

Widget buildHistoryTestApp({required Widget child}) {
  return MaterialApp(
    locale: const Locale('pt', 'BR'),
    localizationsDelegates: const [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: const [Locale('pt', 'BR')],
    home: Scaffold(body: SingleChildScrollView(child: child)),
  );
}

Journey buildHistoryJourney({
  JourneyStatus status = JourneyStatus.completed,
  DateTime? endedAt,
  Duration? duration,
}) {
  final startedAt = DateTime(2025, 5, 14, 8, 3);
  final timestamps = DateTime(2025, 5, 14, 8, 3, 1);

  return Journey(
    id: 1,
    collaboratorId: 4,
    startedAt: startedAt,
    endedAt: endedAt,
    duration: duration,
    plannedActivities: const [],
    status: status,
    createdAt: timestamps,
    updatedAt: timestamps,
  );
}
