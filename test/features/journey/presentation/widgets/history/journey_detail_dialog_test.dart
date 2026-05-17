import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registro_ponto_frontend/features/journey/domain/entities/journey.dart';
import 'package:registro_ponto_frontend/features/journey/domain/entities/journey_planned_activity.dart';
import 'package:registro_ponto_frontend/features/journey/domain/entities/journey_unplanned_activity.dart';
import 'package:registro_ponto_frontend/features/journey/presentation/widgets/history/journey_detail_dialog.dart';

import 'journey_history_test_helpers.dart';

void main() {
  setUpAll(initJourneyHistoryTests);

  final referenceTime = DateTime(2025, 5, 14, 10, 24);

  Future<void> openDialog(WidgetTester tester, {required Journey journey}) async {
    await tester.pumpWidget(
      buildHistoryTestApp(
        child: Builder(
          builder: (context) {
            return TextButton(
              onPressed: () => JourneyDetailDialog.show(
                context,
                journey: journey,
                referenceTime: referenceTime,
              ),
              child: const Text('Abrir'),
            );
          },
        ),
      ),
    );
    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();
  }

  testWidgets('exibe informações principais da jornada', (tester) async {
    final journey = buildHistoryJourney(
      endedAt: DateTime(2025, 5, 14, 18, 5),
      duration: const Duration(hours: 10, minutes: 2),
      summary: 'Dia produtivo',
      plannedActivities: const [
        JourneyPlannedActivity(
          id: 1,
          plannedActivityId: 7,
          description: 'Revisar relatório',
          checked: true,
        ),
      ],
      unplannedActivities: [
        JourneyUnplannedActivity(
          id: 2,
          journeyId: 1,
          description: 'Reunião extra',
          createdAt: DateTime(2025, 5, 14, 11, 0),
        ),
      ],
    );

    await openDialog(tester, journey: journey);

    expect(find.text('Detalhes da jornada'), findsOneWidget);
    expect(find.text('14/05/2025 · Quarta-feira'), findsOneWidget);
    expect(find.text('Finalizada'), findsOneWidget);
    expect(find.text('08:03'), findsOneWidget);
    expect(find.text('18:05'), findsOneWidget);
    expect(find.text('10:02'), findsOneWidget);
    expect(find.text('100%'), findsOneWidget);
    expect(find.text('Dia produtivo'), findsOneWidget);
    expect(find.text('Revisar relatório'), findsOneWidget);
    expect(find.text('Reunião extra'), findsOneWidget);
    expect(find.text('11:00'), findsOneWidget);
  });

  testWidgets('fecha ao tocar em Fechar', (tester) async {
    await openDialog(tester, journey: buildHistoryJourney());

    expect(find.text('Detalhes da jornada'), findsOneWidget);

    await tester.tap(find.text('Fechar'));
    await tester.pumpAndSettle();

    expect(find.text('Detalhes da jornada'), findsNothing);
  });
}
