import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/dio_client_provider.dart';
import '../../domain/repositories/colaborador_repository.dart';
import '../datasources/colaborador_remote_data_source_impl.dart';
import 'colaborador_repository_impl.dart';

part 'colaborador_repository_provider.g.dart';

@Riverpod(keepAlive: true)
ColaboradorRepository colaboradorRepository(Ref ref) {
  return ColaboradorRepositoryImpl(
    remote: ColaboradorRemoteDataSourceImpl(ref.watch(dioClientProvider)),
  );
}
