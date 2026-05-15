import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../presentation/view_models/auth_session_controller.dart';

class AuthInterceptor extends Interceptor {
  static const _loginPath = '/v1/auth/login';

  final Ref _ref;

  AuthInterceptor(this._ref);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (options.headers['Authorization'] == null) {
      final session = _ref.read(authSessionControllerProvider).value;

      if (session != null) {
        options.headers['Authorization'] = '${session.tokenType} ${session.token}';
      }
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final status = err.response?.statusCode;
    final isLoginEndpoint = err.requestOptions.path.contains(_loginPath);

    if (status == 401 && !isLoginEndpoint) {
      unawaited(_ref.read(authSessionControllerProvider.notifier).clear());
    }

    handler.next(err);
  }
}
