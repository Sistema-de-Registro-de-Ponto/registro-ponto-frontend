import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registro_ponto_frontend/shared/app_check_list_item.dart';

void main() {
  testWidgets('item não concluído exibe título sem badge', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AppCheckListItem(
            isChecked: false,
            title: 'Reunião daily',
          ),
        ),
      ),
    );

    expect(find.text('Reunião daily'), findsOneWidget);
    expect(find.text('Concluída'), findsNothing);
    expect(find.byIcon(Icons.check), findsNothing);
  });

  testWidgets('item concluído exibe badge e ícone verde', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AppCheckListItem(
            isChecked: true,
            title: 'Ajustar API de login',
          ),
        ),
      ),
    );

    expect(find.text('Ajustar API de login'), findsOneWidget);
    expect(find.text('Concluída'), findsOneWidget);
    expect(find.byIcon(Icons.check), findsOneWidget);

    final title = tester.widget<Text>(find.text('Ajustar API de login'));
    expect(title.style?.decoration, TextDecoration.lineThrough);
  });

  testWidgets('item com onTap dispara callback ao tocar', (tester) async {
    var tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppCheckListItem(
            isChecked: false,
            title: 'Reunião daily',
            onTap: () => tapped = true,
          ),
        ),
      ),
    );

    await tester.tap(find.text('Reunião daily'));
    await tester.pump();

    expect(tapped, isTrue);
  });
}
