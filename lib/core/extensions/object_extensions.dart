import 'package:flutter/foundation.dart';

extension ObjectExtensions on Object {
  String toErrorString() {
    final error = this;

    debugPrint('error: $error\nstackTrace: ${StackTrace.current}');
    return error.toString();
  }
}
