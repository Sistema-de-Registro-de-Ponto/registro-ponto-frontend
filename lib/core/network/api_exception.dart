import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ApiException implements Exception {
  final String message;

  ApiException([this.message = 'Erro desconhecido']);

  @override
  String toString() => 'ApiError: $message';
}

extension DioExceptionX on DioException {
  ApiException mapDioException() {
    final error = this;
    debugPrint('error: $error\nstackTrace: $stackTrace');

    return switch (error.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.connectionError => ApiException('Erro na conexão'),
      DioExceptionType.badResponse => ApiException(
        _extractDetail(error.response?.data) ?? 'Erro _extractDetail',
      ),
      _ => ApiException(),
    };
  }
}

String? _extractDetail(dynamic data) {
  if (data is String && data.isNotEmpty) return data;
  if (data is! Map<String, dynamic>) return null;

  final errors = data['errors'];
  if (errors is Map) {
    final messages = errors.values
        .whereType<String>()
        .where((m) => m.isNotEmpty)
        .toList();
    if (messages.isNotEmpty) return messages.join('\n');
  }
  if (errors is List && errors.isNotEmpty) {
    final messages = errors
        .whereType<Map<String, dynamic>>()
        .map((e) => e['defaultMessage'] ?? e['message'])
        .whereType<String>()
        .where((m) => m.isNotEmpty)
        .toList();
    if (messages.isNotEmpty) return messages.join('\n');
  }

  final detail = data['detail'];
  if (detail is String && detail.isNotEmpty) return detail;

  final message = data['message'];
  if (message is String && message.isNotEmpty) return message;

  return null;
}
