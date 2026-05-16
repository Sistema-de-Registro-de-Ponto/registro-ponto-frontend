import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registro_ponto_frontend/shared/app_inform_activity.dart';
import 'package:registro_ponto_frontend/shared/app_pending_activity_item.dart';

void main() {
  testWidgets('exibe título, campo e botão de adicionar', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppInformActivity(
            title: 'Adicionar atividade planejada',
            hintText: 'Descreva a atividade...',
            onDescriptionChanged: (_) {},
            onSubmitted: () {},
          ),
        ),
      ),
    );

    expect(find.text('Adicionar atividade planejada'), findsOneWidget);
    expect(find.text('Descreva a atividade...'), findsOneWidget);
    expect(find.text('Adicionar atividade'), findsOneWidget);
  });

  testWidgets('exibe lista de pendentes quando children não está vazio', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppInformActivity(
            title: 'Adicionar atividade planejada',
            hintText: 'Descreva a atividade...',
            onDescriptionChanged: (_) {},
            onSubmitted: () {},
            children: const [
              AppPendingActivityItem(title: 'Reunião com cliente', description: '09:15', onDelete: _noop),
            ],
          ),
        ),
      ),
    );

    expect(find.text('Reunião com cliente'), findsOneWidget);
    expect(find.text('09:15'), findsOneWidget);
    expect(find.byIcon(Icons.delete_outline), findsOneWidget);
  });

  testWidgets('dispara onSubmitted ao tocar no botão', (tester) async {
    var submitted = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppInformActivity(
            title: 'Adicionar atividade planejada',
            hintText: 'Descreva a atividade...',
            onDescriptionChanged: (_) {},
            onSubmitted: () => submitted = true,
          ),
        ),
      ),
    );

    await tester.tap(find.text('Adicionar atividade'));
    await tester.pump();

    expect(submitted, isTrue);
  });

  testWidgets('com interactionEnabled false não dispara onSubmitted ao tocar no botão', (tester) async {
    var submitted = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppInformActivity(
            title: 'Adicionar atividade planejada',
            hintText: 'Descreva a atividade...',
            interactionEnabled: false,
            onDescriptionChanged: (_) {},
            onSubmitted: () => submitted = true,
          ),
        ),
      ),
    );

    await tester.tap(find.text('Adicionar atividade'));
    await tester.pump();

    expect(submitted, isFalse);
  });
}

void _noop() {}
