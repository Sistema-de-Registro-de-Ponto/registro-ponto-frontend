import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/dio_client_provider.dart';
import '../../domain/repositories/manager_repository.dart';
import '../datasources/manager_remote_data_source_impl.dart';
import 'manager_repository_impl.dart';

part 'manager_repository_provider.g.dart';

@Riverpod(keepAlive: true)
ManagerRepository managerRepository(Ref ref) {
  return ManagerRepositoryImpl(
    remote: ManagerRemoteDataSourceImpl(ref.watch(dioClientProvider)),
  );
}
