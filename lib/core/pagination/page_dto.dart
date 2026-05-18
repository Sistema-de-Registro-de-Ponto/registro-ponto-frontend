import 'page.dart';

class PageDto<T> {
  final List<T> content;
  final int pageNumber;
  final int pageSize;
  final int totalElements;
  final bool isFirst;
  final bool isLast;
  final bool empty;

  const PageDto({
    required this.content,
    required this.pageNumber,
    required this.pageSize,
    required this.totalElements,
    required this.isFirst,
    required this.isLast,
    required this.empty,
  });

  factory PageDto.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic> json) itemFromJson,
  ) {
    return PageDto(
      content: (json['content'] as List)
          .map((item) => itemFromJson(item as Map<String, dynamic>))
          .toList(),
      pageNumber: json['number'] as int,
      pageSize: json['size'] as int,
      totalElements: json['numberOfElements'] as int,
      isFirst: json['first'] as bool,
      isLast: json['last'] as bool,
      empty: json['empty'] as bool,
    );
  }

  Page<E> toEntity<E>(E Function(T dto) itemToEntity) {
    return Page(
      content: content.map(itemToEntity).toList(),
      pageNumber: pageNumber,
      pageSize: pageSize,
      totalElements: totalElements,
      isFirst: isFirst,
      isLast: isLast,
      empty: empty,
    );
  }
}
