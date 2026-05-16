import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:registro_ponto_frontend/core/utils/result.dart';
import 'package:registro_ponto_frontend/features/journey/data/repositories/journey_repository_provider.dart';
import 'package:registro_ponto_frontend/features/journey/domain/entities/journey.dart';
import 'package:registro_ponto_frontend/features/journey/domain/entities/journey_status.dart';
import 'package:registro_ponto_frontend/features/journey/domain/repositories/journey_repository.dart';
import 'package:registro_ponto_frontend/features/journey/presentation/widgets/unplanned_activities_section.dart';

class _MockJourneyRepository extends Mock implements JourneyRepository {}

void main() {
  late _MockJourneyRepository repo;

  final startedAt = DateTime.parse('2026-05-15T08:03:00-03:00').toLocal();
  final createdAt = DateTime.parse('2026-05-15T08:03:01-03:00').toLocal();
  final updatedAt = DateTime.parse('2026-05-15T08:03:01-03:00').toLocal();

  final journeyInProgress = Journey(
    id: 10,
    collaboratorId: 4,
    startedAt: startedAt,
    plannedActivities: const [],
    status: JourneyStatus.inProgress,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );

  Widget buildSubject() {
    return ProviderScope(
      overrides: [journeyRepositoryProvider.overrideWithValue(repo)],
      child: const MaterialApp(home: Scaffold(body: UnplannedActivitiesSection())),
    );
  }

  setUp(() {
    repo = _MockJourneyRepository();
    when(() => repo.fetchInProgressJourney())
        .thenAnswer((_) async => const Success<Journey?, String>(null));
  });

  testWidgets('oculta quando não há jornada em andamento ou concluída', (tester) async {
    await tester.pumpWidget(buildSubject());
    await tester.pump();

    expect(find.text('Adicionar atividade não planejada'), findsNothing);
  });

  testWidgets('exibe formulário quando a jornada está em andamento', (tester) async {
    when(() => repo.fetchInProgressJourney())
        .thenAnswer((_) async => Success<Journey?, String>(journeyInProgress));

    await tester.pumpWidget(buildSubject());
    await tester.pump();

    expect(find.text('Adicionar atividade não planejada'), findsOneWidget);
    expect(find.text('Descreva a atividade...'), findsOneWidget);
  });
}
