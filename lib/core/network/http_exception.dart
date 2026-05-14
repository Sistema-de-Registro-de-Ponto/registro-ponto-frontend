sealed class HttpException implements Exception {
  const HttpException();
}

final class NetworkException extends HttpException {
  const NetworkException();
}

final class ApiException extends HttpException {
  final int statusCode;
  final String? detail;

  const ApiException({required this.statusCode, this.detail});
}

final class UnknownHttpException extends HttpException {
  final Object cause;

  const UnknownHttpException(this.cause);
}
