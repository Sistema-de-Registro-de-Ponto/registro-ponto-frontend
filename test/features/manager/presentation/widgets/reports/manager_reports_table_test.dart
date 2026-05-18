import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registro_ponto_frontend/features/manager/domain/entities/manager_consolidated_report_collaborator.dart';
import 'package:registro_ponto_frontend/features/manager/presentation/widgets/reports/manager_reports_table.dart';

void main() {
  testWidgets('exibe colunas e métricas do colaborador', (tester) async {
    const collaborator = ManagerConsolidatedReportCollaborator(
      id: 1,
      firstName: 'Natanael',
      durationSeconds: 12600,
      plannedActivities: 10,
      activitiesCompleted: 7,
      unplannedActivities: 2,
      adherencePercentage: 70,
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ManagerReportsTable(collaborators: [collaborator]),
        ),
      ),
    );

    expect(find.text('Natanael'), findsOneWidget);
    expect(find.text('03:30'), findsOneWidget);
    expect(find.text('10'), findsOneWidget);
    expect(find.text('7'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
    expect(find.text('70%'), findsOneWidget);
    expect(find.byTooltip('Ver detalhes'), findsNothing);
  });

  testWidgets('exibe mensagem quando lista está vazia', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ManagerReportsTable(collaborators: []),
        ),
      ),
    );

    expect(find.text('Nenhum colaborador encontrado.'), findsOneWidget);
  });
}
