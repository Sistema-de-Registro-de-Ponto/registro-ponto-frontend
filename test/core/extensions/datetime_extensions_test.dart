import 'package:flutter_test/flutter_test.dart';
import 'package:registro_ponto_frontend/core/extensions/datetime_extensions.dart';

void main() {
  test('formattedApiDate formata como yyyy-MM-dd', () {
    final date = DateTime(2025, 5, 14);

    expect(date.formattedApiDate, '2025-05-14');
  });

  test('formattedShortDate formata como dd/MM/yyyy', () {
    final date = DateTime(2025, 5, 14);

    expect(date.formattedShortDate, '14/05/2025');
  });

  test('formattedHm formata duração como HH:mm', () {
    expect(const Duration(hours: 10, minutes: 2).formattedHm, '10:02');
    expect(const Duration(hours: 2, minutes: 21).formattedHm, '02:21');
  });
}
