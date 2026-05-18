import 'package:flutter_test/flutter_test.dart';
import 'package:registro_ponto_frontend/core/extensions/datetime_extensions.dart';
import 'package:registro_ponto_frontend/features/activity/data/models/planned_activity_dto.dart';

void main() {
  final createdAt = DateTime.parse(
    '2026-05-15T12:08:22.904747-03:00',
  ).toLocal();

  test('fromJson mapeia id, description e created_at', () {
    final dto = PlannedActivityDto.fromJson({
      'id': 7,
      'description': 'Reunião com cliente',
      'created_at': '2026-05-15T12:08:22.904747-03:00',
    });

    expect(dto.id, 7);
    expect(dto.description, 'Reunião com cliente');
    expect(dto.createdAt, createdAt);
    expect(dto.toEntity().timeLabel, createdAt.formattedHourShort);
  });

  test('toJson serializa id e description', () {
    final dto = PlannedActivityDto(
      id: 3,
      description: 'Code review',
      createdAt: createdAt,
    );
    expect(dto.toJson(), {'id': 3, 'description': 'Code review'});
  });
}
