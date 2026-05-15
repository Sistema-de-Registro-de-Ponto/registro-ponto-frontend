import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/dio_client_provider.dart';
import '../../domain/repositories/journey_repository.dart';
import '../datasources/journey_remote_data_source_impl.dart';
import 'journey_repository_impl.dart';

part 'journey_repository_provider.g.dart';

@Riverpod(keepAlive: true)
JourneyRepository journeyRepository(Ref ref) {
  return JourneyRepositoryImpl(
    remote: JourneyRemoteDataSourceImpl(ref.watch(dioClientProvider)),
  );
}
