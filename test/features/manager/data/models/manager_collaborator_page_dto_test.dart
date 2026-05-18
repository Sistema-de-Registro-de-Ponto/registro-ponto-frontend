import 'package:flutter_test/flutter_test.dart';
import 'package:registro_ponto_frontend/core/pagination/page_dto.dart';
import 'package:registro_ponto_frontend/features/manager/data/models/manager_collaborator_dto.dart';

void main() {
  test('mapeia página Spring de colaboradores', () {
    final dto = PageDto.fromJson(
      <String, dynamic>{
        'content': [
          <String, dynamic>{
            'id': 1,
            'first_name': 'Maria',
            'current_journey_status': 'in_progress',
            'hours_today_seconds': 8100,
            'adherence_percentage': 95,
          },
        ],
        'number': 0,
        'size': 10,
        'total_elements': 25,
        'first': true,
        'last': false,
        'empty': false,
      },
      ManagerCollaboratorDto.fromJson,
    );

    expect(dto.content, hasLength(1));
    expect(dto.content.first.firstName, 'Maria');
    expect(dto.pageNumber, 0);
    expect(dto.pageSize, 10);
    expect(dto.totalElements, 25);
    expect(dto.isFirst, isTrue);
    expect(dto.isLast, isFalse);

    final page = dto.toEntity((item) => item.toEntity());
    expect(page.content.first.firstName, 'Maria');
    expect(page.totalElements, 25);
  });
}
