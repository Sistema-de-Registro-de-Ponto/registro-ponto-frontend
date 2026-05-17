import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registro_ponto_frontend/features/journey/presentation/widgets/history/journey_history_table.dart';

import 'journey_history_test_helpers.dart';

void main() {
  setUpAll(initJourneyHistoryTests);

  final referenceTime = DateTime(2025, 5, 14, 10, 24);

  testWidgets('exibe ícone para ver detalhes e abre o diálogo', (tester) async {
    final journey = buildHistoryJourney(
      endedAt: DateTime(2025, 5, 14, 18, 5),
      duration: const Duration(hours: 10, minutes: 2),
    );

    await tester.pumpWidget(
      buildHistoryTestApp(
        child: JourneyHistoryTable(
          journeys: [journey],
          referenceTime: referenceTime,
        ),
      ),
    );

    expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);

    await tester.tap(find.byTooltip('Ver detalhes'));
    await tester.pumpAndSettle();

    expect(find.text('Detalhes da jornada'), findsOneWidget);
    expect(find.text('14/05/2025 · Quarta-feira'), findsOneWidget);
  });
}
