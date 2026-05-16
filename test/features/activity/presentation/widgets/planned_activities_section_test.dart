import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:registro_ponto_frontend/core/utils/result.dart';
import 'package:registro_ponto_frontend/features/activity/data/repositories/activity_repository_provider.dart';
import 'package:registro_ponto_frontend/features/activity/domain/entities/planned_activity.dart';
import 'package:registro_ponto_frontend/features/activity/domain/repositories/activity_repository.dart';
import 'package:registro_ponto_frontend/features/activity/presentation/view_models/activity_view_model.dart';
import 'package:registro_ponto_frontend/features/activity/presentation/widgets/planned_activities_section.dart';

class _MockActivityRepository extends Mock implements ActivityRepository {}

void main() {
  late _MockActivityRepository repo;

  final createdAt = DateTime.parse('2026-05-15T12:00:00-03:00').toLocal();
  final activity = PlannedActivity(
    id: 1,
    description: 'Reunião daily',
    createdAt: createdAt,
  );

  Widget buildSubject() {
    return ProviderScope(
      overrides: [activityRepositoryProvider.overrideWithValue(repo)],
      child: const MaterialApp(home: Scaffold(body: PlannedActivitiesSection())),
    );
  }

  setUp(() {
    repo = _MockActivityRepository();
    when(() => repo.fetchPlannedActivities())
        .thenAnswer((_) async => Success<List<PlannedActivity>, String>([activity]));
  });

  testWidgets('só remove atividade planejada após confirmação', (tester) async {
    when(() => repo.deletePlannedActivity(id: 1))
        .thenAnswer((_) async => Success<PlannedActivity, String>(activity));

    await tester.pumpWidget(buildSubject());
    await tester.pump();

    final element = tester.element(find.byType(PlannedActivitiesSection));
    final scope = ProviderScope.containerOf(element);
    await scope.read(activityViewModelProvider.notifier).loadPlannedActivities();
    await tester.pump();

    await tester.tap(find.byTooltip('Remover atividade'));
    await tester.pumpAndSettle();

    expect(find.text('Remover atividade?'), findsOneWidget);
    verifyNever(() => repo.deletePlannedActivity(id: 1));

    await tester.tap(find.text('Remover'));
    await tester.pumpAndSettle();

    verify(() => repo.deletePlannedActivity(id: 1)).called(1);
  });
}
