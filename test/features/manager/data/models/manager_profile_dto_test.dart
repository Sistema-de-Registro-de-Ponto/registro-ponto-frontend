import 'package:flutter_test/flutter_test.dart';
import 'package:registro_ponto_frontend/features/manager/data/models/manager_profile_dto.dart';

void main() {
  test('fromJson mapeia user_id e first_name', () {
    const json = {
      'user_id': 7,
      'first_name': 'Maria',
    };
    final dto = ManagerProfileDto.fromJson(json);
    expect(dto.userId, 7);
    expect(dto.firstName, 'Maria');
    expect(dto.toEntity().userId, 7);
    expect(dto.toEntity().firstName, 'Maria');
  });
}
