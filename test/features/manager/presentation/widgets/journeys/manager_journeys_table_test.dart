import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:registro_ponto_frontend/features/journey/domain/entities/journey_status.dart';
import 'package:registro_ponto_frontend/features/manager/domain/entities/manager_journey_list_item.dart';
import 'package:registro_ponto_frontend/features/manager/presentation/widgets/journeys/manager_journeys_table.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('pt_BR');
  });

  testWidgets('exibe colunas e dispara callback ao ver detalhes', (tester) async {
    ManagerJourneyListItem? tapped;

    final journey = ManagerJourneyListItem(
      id: 42,
      journeyDate: DateTime(2025, 5, 14),
      collaboratorId: 1,
      collaboratorFirstName: 'Maria Silva',
      startedAt: DateTime(2025, 5, 14, 8, 3),
      duration: const Duration(hours: 2, minutes: 21),
      status: JourneyStatus.inProgress,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ManagerJourneysTable(
            journeys: [journey],
            referenceTime: DateTime(2025, 5, 14, 10, 24),
            onViewDetails: (item) => tapped = item,
          ),
        ),
      ),
    );

    expect(find.text('Maria Silva'), findsOneWidget);
    expect(find.text('08:03'), findsOneWidget);
    expect(find.text('02:21'), findsOneWidget);
    expect(find.text('Em andamento'), findsNWidgets(2));
    expect(find.text('ADERÊNCIA'), findsNothing);

    await tester.tap(find.byTooltip('Ver detalhes'));
    await tester.pump();

    expect(tapped, journey);
  });
}
