import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/dio_client_provider.dart';
import '../../domain/repositories/collaborator_repository.dart';
import '../datasources/collaborator_remote_data_source_impl.dart';
import 'collaborator_repository_impl.dart';

part 'collaborator_repository_provider.g.dart';

@Riverpod(keepAlive: true)
CollaboratorRepository collaboratorRepository(Ref ref) {
  return CollaboratorRepositoryImpl(
    remote: CollaboratorRemoteDataSourceImpl(ref.watch(dioClientProvider)),
  );
}
