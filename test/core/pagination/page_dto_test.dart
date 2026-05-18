import 'package:flutter_test/flutter_test.dart';
import 'package:registro_ponto_frontend/core/pagination/page_dto.dart';

void main() {
  test('mapeia página Spring com content e metadados', () {
    final dto = PageDto.fromJson(<String, dynamic>{
      'content': [
        <String, dynamic>{'id': 1, 'name': 'Maria'},
      ],
      'number': 0,
      'size': 10,
      'totalElements': 25,
      'first': true,
      'last': false,
      'empty': false,
    }, (json) => json['name'] as String);

    expect(dto.content, ['Maria']);
    expect(dto.pageNumber, 0);
    expect(dto.pageSize, 10);
    expect(dto.totalElements, 25);
    expect(dto.isFirst, isTrue);
    expect(dto.isLast, isFalse);
    expect(dto.empty, isFalse);

    final page = dto.toEntity((name) => name.toUpperCase());
    expect(page.content, ['MARIA']);
    expect(page.hasMore, isTrue);
  });
}
