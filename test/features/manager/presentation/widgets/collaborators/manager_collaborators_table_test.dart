import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registro_ponto_frontend/features/journey/domain/entities/journey_status.dart';
import 'package:registro_ponto_frontend/features/manager/domain/entities/manager_collaborator.dart';
import 'package:registro_ponto_frontend/features/manager/presentation/widgets/collaborators/manager_collaborators_table.dart';

void main() {
  testWidgets('exibe colunas e dispara callback ao ver detalhes', (tester) async {
  ManagerCollaborator? tapped;

  const collaborator = ManagerCollaborator(
    id: 1,
    firstName: 'Maria Silva',
    currentJourneyStatus: JourneyStatus.inProgress,
    hoursTodaySeconds: 8100,
    adherencePercentage: 95,
  );

  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: ManagerCollaboratorsTable(
          collaborators: const [collaborator],
          onViewDetails: (item) => tapped = item,
        ),
      ),
    ),
  );

  expect(find.text('Maria Silva'), findsOneWidget);
  expect(find.text('02:15'), findsOneWidget);
  expect(find.text('95%'), findsOneWidget);
  expect(find.text('EM ANDAMENTO'), findsOneWidget);

  await tester.tap(find.byTooltip('Ver detalhes'));
  await tester.pump();

  expect(tapped, collaborator);
  });
}
