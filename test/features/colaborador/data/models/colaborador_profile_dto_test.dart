import 'package:flutter_test/flutter_test.dart';
import 'package:registro_ponto_frontend/features/collaborator/data/models/collaborator_profile_dto.dart';

void main() {
  test('fromJson mapeia user_id e first_name', () {
    const json = {'user_id': 42, 'first_name': 'Natanael'};
    final dto = CollaboratorProfileDto.fromJson(json);
    expect(dto.userId, 42);
    expect(dto.firstName, 'Natanael');
    expect(dto.toEntity().userId, 42);
    expect(dto.toEntity().firstName, 'Natanael');
  });
}
