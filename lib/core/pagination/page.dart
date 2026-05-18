import 'package:equatable/equatable.dart';

class Page<T> extends Equatable {
  final List<T> content;
  final int pageNumber;
  final int pageSize;
  final int totalElements;
  final bool isFirst;
  final bool isLast;
  final bool empty;

  const Page({
    required this.content,
    required this.pageNumber,
    required this.pageSize,
    required this.totalElements,
    required this.isFirst,
    required this.isLast,
    required this.empty,
  });

  bool get hasMore => !isLast;

  @override
  List<Object?> get props => [
    content,
    pageNumber,
    pageSize,
    totalElements,
    isFirst,
    isLast,
    empty,
  ];
}
