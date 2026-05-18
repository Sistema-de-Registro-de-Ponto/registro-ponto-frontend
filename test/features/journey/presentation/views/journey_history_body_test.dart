import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:registro_ponto_frontend/core/utils/result.dart';
import 'package:registro_ponto_frontend/features/journey/data/repositories/journey_repository_provider.dart';
import 'package:registro_ponto_frontend/features/journey/domain/entities/journey_page.dart';
import 'package:registro_ponto_frontend/features/journey/domain/repositories/journey_repository.dart';
import 'package:registro_ponto_frontend/features/journey/presentation/view_models/journey_history_view_model.dart';
import 'package:registro_ponto_frontend/features/journey/presentation/views/journey_history_body.dart';

import '../widgets/history/journey_history_test_helpers.dart';

class _MockJourneyRepository extends Mock implements JourneyRepository {}

void main() {
  late _MockJourneyRepository repo;

  setUpAll(initJourneyHistoryTests);

  setUp(() {
    repo = _MockJourneyRepository();
  });

  Widget buildApp() {
    return ProviderScope(
      overrides: [journeyRepositoryProvider.overrideWithValue(repo)],
      child: buildHistoryTestApp(child: const JourneyHistoryBody()),
    );
  }

  testWidgets('exibe histórico após loadJourneys', (tester) async {
    final journey = buildHistoryJourney();

    when(
      () => repo.fetchJourneys(
        startDate: any(named: 'startDate'),
        endDate: any(named: 'endDate'),
        page: 0,
        pageSize: 20,
      ),
    ).thenAnswer(
      (_) async => Success(JourneyPage(journeys: [journey], last: true)),
    );

    await tester.pumpWidget(buildApp());

    await ProviderScope.containerOf(
      tester.element(find.byType(JourneyHistoryBody)),
    ).read(journeyHistoryViewModelProvider.notifier).loadJourneys();
    await tester.pumpAndSettle();

    expect(find.text('Histórico de Jornadas'), findsOneWidget);
    expect(find.text('Finalizada'), findsOneWidget);
  });

  testWidgets('falha inicial exibe retry', (tester) async {
    when(
      () => repo.fetchJourneys(
        startDate: any(named: 'startDate'),
        endDate: any(named: 'endDate'),
        page: any(named: 'page'),
        pageSize: any(named: 'pageSize'),
      ),
    ).thenAnswer((_) async => const Failure('Erro no histórico'));

    await tester.pumpWidget(buildApp());
    await ProviderScope.containerOf(
      tester.element(find.byType(JourneyHistoryBody)),
    ).read(journeyHistoryViewModelProvider.notifier).loadJourneys();
    await tester.pumpAndSettle();

    expect(find.text('Erro no histórico'), findsOneWidget);
    expect(find.text('Tentar novamente'), findsOneWidget);
  });
}
