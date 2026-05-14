import 'package:equatable/equatable.dart';

sealed class AuthFailure extends Equatable {
  const AuthFailure();

  @override
  List<Object?> get props => const [];
}

final class InvalidCredentialsFailure extends AuthFailure {
  final String? detail;

  const InvalidCredentialsFailure({this.detail});

  @override
  List<Object?> get props => [detail];
}

final class NetworkFailure extends AuthFailure {
  const NetworkFailure();
}

final class ServerFailure extends AuthFailure {
  final int statusCode;
  final String? detail;

  const ServerFailure(this.statusCode, {this.detail});

  @override
  List<Object?> get props => [statusCode, detail];
}

final class UnauthorizedFailure extends AuthFailure {
  final String? detail;

  const UnauthorizedFailure({this.detail});

  @override
  List<Object?> get props => [detail];
}

final class UnknownFailure extends AuthFailure {
  final Object cause;

  const UnknownFailure(this.cause);

  @override
  List<Object?> get props => [cause];
}
