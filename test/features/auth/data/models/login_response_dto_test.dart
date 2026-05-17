import 'package:flutter_test/flutter_test.dart';
import 'package:registro_ponto_frontend/features/auth/data/models/login_response_dto.dart';
import 'package:registro_ponto_frontend/features/auth/domain/entities/user_role.dart';

void main() {
  test('fromJson mapeia token, tokenType e role COLLABORATOR', () {
    const json = {
      'token': 'eyJ',
      'tokenType': 'Bearer',
      'role': 'COLLABORATOR',
    };
    final dto = LoginResponseDto.fromJson(json);
    expect(dto.token, 'eyJ');
    expect(dto.tokenType, 'Bearer');
    expect(dto.role, UserRole.collaborator);
  });

  test('fromJson mapeia role MANAGER', () {
    const json = {
      'token': 'eyJ',
      'tokenType': 'Bearer',
      'role': 'MANAGER',
    };
    final dto = LoginResponseDto.fromJson(json);
    expect(dto.role, UserRole.manager);
  });
}
