import 'package:equatable/equatable.dart';

sealed class Result<S, F> extends Equatable {
  const Result();
}

final class Success<S, F> extends Result<S, F> {
  final S value;

  const Success(this.value);

  @override
  List<Object?> get props => [value];
}

final class Failure<S, F> extends Result<S, F> {
  final F error;

  const Failure(this.error);

  @override
  List<Object?> get props => [error];
}
