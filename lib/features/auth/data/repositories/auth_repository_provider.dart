import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/dio_client_provider.dart';
import '../../../../core/storage/secure_storage_provider.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_local_data_source_impl.dart';
import '../datasources/auth_remote_data_source.dart';
import '../datasources/auth_remote_data_source_impl.dart';
import 'auth_repository_impl.dart';

part 'auth_repository_provider.g.dart';

@Riverpod(keepAlive: true)
AuthRemoteDataSource authRemoteDataSource(Ref ref) =>
    AuthRemoteDataSourceImpl(ref.watch(dioClientProvider));

@Riverpod(keepAlive: true)
AuthLocalDataSource authLocalDataSource(Ref ref) =>
    AuthLocalDataSourceImpl(ref.watch(secureStorageProvider));

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) => AuthRepositoryImpl(
      remote: ref.watch(authRemoteDataSourceProvider),
      local: ref.watch(authLocalDataSourceProvider),
    );
