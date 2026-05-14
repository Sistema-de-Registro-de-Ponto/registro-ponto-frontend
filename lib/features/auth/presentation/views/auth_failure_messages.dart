import '../../domain/failures/auth_failure.dart';

String messageFor(AuthFailure failure) {
  return switch (failure) {
    InvalidCredentialsFailure() =>
      failure.detail ?? 'Usuário ou senha inválidos.',
    NetworkFailure() => 'Sem conexão. Verifique sua internet.',
    UnauthorizedFailure() =>
      failure.detail ?? 'Sua sessão expirou. Faça login novamente.',
    ServerFailure() =>
      failure.detail ??
          'Erro no servidor (${failure.statusCode}). Tente novamente mais tarde.',
    UnknownFailure() => 'Ocorreu um erro inesperado. Tente novamente.',
  };
}
