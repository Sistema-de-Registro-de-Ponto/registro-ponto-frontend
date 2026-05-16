import 'package:flutter/foundation.dart';

extension ObjectExtensions on Object {
  String toErrorString() {
    final error = this;

    if (error is Error) {
      debugPrint('error: $error\nstackTrace: ${error.stackTrace}');
    } else {
      debugPrint('error: $error');
    }

    return error.toString();
  }
}
