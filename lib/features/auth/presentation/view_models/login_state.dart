import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class LoginState extends Equatable {
  final String username;
  final String password;
  final bool passwordVisible;
  final bool isLoading;
  final String? failure;

  const LoginState({
    this.username = '',
    this.password = '',
    this.passwordVisible = false,
    this.isLoading = false,
    this.failure,
  });

  LoginState copyWith({
    String? username,
    String? password,
    bool? passwordVisible,
    bool? isLoading,
    ValueGetter<String?>? failure,
  }) {
    return LoginState(
      username: username ?? this.username,
      password: password ?? this.password,
      passwordVisible: passwordVisible ?? this.passwordVisible,
      isLoading: isLoading ?? this.isLoading,
      failure: failure != null ? failure() : this.failure,
    );
  }

  @override
  List<Object?> get props => [username, password, passwordVisible, isLoading, failure];
}
