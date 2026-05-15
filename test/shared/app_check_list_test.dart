import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registro_ponto_frontend/shared/app_check_list.dart';
import 'package:registro_ponto_frontend/shared/app_check_list_item.dart';

void main() {
  testWidgets('exibe título e itens da lista', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AppCheckList(
            title: 'Atividades planejadas para hoje',
            items: [
              AppCheckListItem(isChecked: true, title: 'Tarefa A'),
              AppCheckListItem(isChecked: false, title: 'Tarefa B'),
            ],
          ),
        ),
      ),
    );

    expect(find.text('Atividades planejadas para hoje'), findsOneWidget);
    expect(find.text('Tarefa A'), findsOneWidget);
    expect(find.text('Tarefa B'), findsOneWidget);
  });
}
