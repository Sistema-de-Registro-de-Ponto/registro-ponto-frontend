import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'flutter_secure_storage_adapter.dart';
import 'secure_storage.dart';

part 'secure_storage_provider.g.dart';

@Riverpod(keepAlive: true)
SecureStorage secureStorage(Ref ref) =>
    const FlutterSecureStorageAdapter(FlutterSecureStorage());
