import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registro_ponto_frontend/shared/app_elapsed_time.dart';

void main() {
  testWidgets('sem canBegin exibe placeholder', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AppElapsedTime(canBegin: false),
        ),
      ),
    );

    expect(find.text('Tempo decorrido'), findsOneWidget);
    expect(find.text('--:--:--'), findsOneWidget);
  });

  testWidgets('com canBegin atualiza o timer a cada segundo', (tester) async {
    final startedAt = DateTime(2026, 5, 15, 8, 0, 0);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppElapsedTime(
            canBegin: true,
            startedAt: startedAt,
          ),
        ),
      ),
    );

    expect(find.textContaining(':'), findsWidgets);

    await tester.pump(const Duration(seconds: 1));

    expect(find.text('Tempo decorrido'), findsOneWidget);
  });
}
