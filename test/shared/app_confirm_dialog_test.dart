import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registro_ponto_frontend/shared/app_confirm_dialog.dart';

void main() {
  testWidgets('retorna true quando o utilizador confirma', (tester) async {
    bool? confirmed;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return FilledButton(
                onPressed: () async {
                  confirmed = await AppConfirmDialog.show(
                    context,
                    title: 'Título',
                    message: 'Mensagem',
                  );
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

    expect(find.text('Título'), findsOneWidget);
    expect(find.text('Mensagem'), findsOneWidget);

    await tester.tap(find.text('Confirmar'));
    await tester.pumpAndSettle();

    expect(confirmed, isTrue);
  });

  testWidgets('retorna false quando o utilizador cancela', (tester) async {
    bool? confirmed;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return FilledButton(
                onPressed: () async {
                  confirmed = await AppConfirmDialog.show(
                    context,
                    title: 'Título',
                    message: 'Mensagem',
                  );
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
    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();

    expect(confirmed, isFalse);
  });
}
