import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registro_ponto_frontend/shared/app_journey.dart';

void main() {
  testWidgets('status waiting exibe headline e badge aguardando', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AppJourney(status: AppJourneyStatus.waiting),
        ),
      ),
    );

    expect(find.text('JORNADA PRONTA PARA INICIAR'), findsOneWidget);
    expect(find.text('AGUARDANDO'), findsOneWidget);
    expect(find.text('ENCERRAR JORNADA'), findsNothing);
  });

  testWidgets('status inProgress exibe hora de início e botão encerrar', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppJourney(
            status: AppJourneyStatus.inProgress,
            startedHour: '08:03',
            startedAt: DateTime(2026, 5, 15, 8, 3),
            onEndJourney: () {},
          ),
        ),
      ),
    );

    expect(find.text('JORNADA EM ANDAMENTO'), findsOneWidget);
    expect(find.text('EM ANDAMENTO'), findsOneWidget);
    expect(find.text('Iniciada às 08:03'), findsOneWidget);
    expect(find.text('ENCERRAR JORNADA'), findsOneWidget);
  });

  testWidgets('botão encerrar fica desabilitado sem callback', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppJourney(
            status: AppJourneyStatus.inProgress,
            startedAt: DateTime(2026, 5, 15, 8, 3),
          ),
        ),
      ),
    );

    final button = tester.widget<FilledButton>(find.byType(FilledButton));
    expect(button.onPressed, isNull);
  });
}
