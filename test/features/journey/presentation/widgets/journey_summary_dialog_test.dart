import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registro_ponto_frontend/features/journey/presentation/widgets/journey_summary_dialog.dart';

void main() {
  testWidgets('retorna resumo trimado ao confirmar', (tester) async {
    String? result;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return FilledButton(
                onPressed: () async {
                  result = await JourneySummaryDialog.show(context);
                },
                child: const Text('Abrir'),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField), '  Dia produtivo.  ');
    await tester.tap(find.text('Encerrar jornada'));
    await tester.pumpAndSettle();

    expect(result, 'Dia produtivo.');
  });

  testWidgets('exige resumo e retorna null ao cancelar', (tester) async {
    String? result;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return FilledButton(
                onPressed: () async {
                  result = await JourneySummaryDialog.show(context);
                },
                child: const Text('Abrir'),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Encerrar jornada'));
    await tester.pumpAndSettle();

    expect(find.text('Campo obrigatório'), findsOneWidget);
    expect(result, isNull);

    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();

    expect(result, isNull);
  });
}
