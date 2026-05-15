import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registro_ponto_frontend/app/theme.dart';
import 'package:registro_ponto_frontend/shared/app_brand_logo.dart';

void main() {
  testWidgets('AppBrandLogo exibe o nome do produto', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildAppTheme(),
        home: const Scaffold(
          body: Center(
            child: AppBrandLogo(compact: true),
          ),
        ),
      ),
    );

    expect(find.text('Registro de Ponto'), findsOneWidget);
  });
}
