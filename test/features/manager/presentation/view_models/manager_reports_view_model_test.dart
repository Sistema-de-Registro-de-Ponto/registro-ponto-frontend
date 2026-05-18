import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:registro_ponto_frontend/core/pagination/page.dart' as pagination;
import 'package:registro_ponto_frontend/core/utils/result.dart';
import 'package:registro_ponto_frontend/features/manager/data/repositories/manager_repository_provider.dart';
import 'package:registro_ponto_frontend/features/manager/domain/entities/manager_consolidated_report.dart';
import 'package:registro_ponto_frontend/features/manager/domain/entities/manager_consolidated_report_collaborator.dart';
import 'package:registro_ponto_frontend/features/manager/domain/entities/manager_consolidated_report_summary.dart';
import 'package:registro_ponto_frontend/features/manager/domain/repositories/manager_repository.dart';
import 'package:registro_ponto_frontend/features/manager/presentation/view_models/manager_reports_view_model.dart';

class _MockRepository extends Mock implements ManagerRepository {}

void main() {
  late _MockRepository repository;
  late ProviderContainer container;

  const summary = ManagerConsolidatedReportSummary(
    durationSeconds: 45000,
    plannedActivities: 42,
    activitiesCompleted: 30,
    unplannedActivities: 8,
    averageAdherencePercentage: 71,
  );

  final collaborator = ManagerConsolidatedReportCollaborator(
    id: 1,
    firstName: 'Natanael',
    durationSeconds: 12600,
    plannedActivities: 10,
    activitiesCompleted: 7,
    unplannedActivities: 2,
    adherencePercentage: 70,
  );

  final report = ManagerConsolidatedReport(
    startDate: DateTime(2026, 5, 1),
    endDate: DateTime(2026, 5, 18),
    summary: summary,
    collaborators: pagination.Page(
      content: [collaborator],
      pageNumber: 0,
      pageSize: 10,
      totalElements: 1,
      isFirst: true,
      isLast: true,
      empty: false,
    ),
  );

  setUp(() {
    repository = _MockRepository();
    container = ProviderContainer(
      overrides: [managerRepositoryProvider.overrideWithValue(repository)],
    );
  });

  tearDown(() => container.dispose());

  ManagerReportsViewModel notifier() =>
      container.read(managerReportsViewModelProvider.notifier);

  test('loadReport envia período de hoje na primeira carga', () async {
    when(
      () => repository.fetchConsolidatedReport(
        startDate: any(named: 'startDate'),
        endDate: any(named: 'endDate'),
        page: 0,
        pageSize: 10,
        search: null,
      ),
    ).thenAnswer((_) async => Success(report));

    await notifier().loadReport();

    final state = container.read(managerReportsViewModelProvider);
    expect(state.summary, summary);
    expect(state.collaborators, [collaborator]);
    expect(state.totalElements, 1);
  });

  test('changePeriod envia novo intervalo na próxima carga', () async {
    when(
      () => repository.fetchConsolidatedReport(
        startDate: DateTime(2026, 5, 1),
        endDate: DateTime(2026, 5, 18),
        page: 0,
        pageSize: 10,
        search: null,
      ),
    ).thenAnswer((_) async => Success(report));

    await notifier().changePeriod(
      DateTimeRange(
        start: DateTime(2026, 5, 1),
        end: DateTime(2026, 5, 18),
      ),
    );

    verify(
      () => repository.fetchConsolidatedReport(
        startDate: DateTime(2026, 5, 1),
        endDate: DateTime(2026, 5, 18),
        page: 0,
        pageSize: 10,
        search: null,
      ),
    ).called(1);
  });
}
