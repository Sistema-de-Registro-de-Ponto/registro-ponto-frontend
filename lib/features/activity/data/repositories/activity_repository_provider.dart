import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/dio_client_provider.dart';
import '../../domain/repositories/activity_repository.dart';
import '../datasources/activity_remote_data_source_impl.dart';
import 'activity_repository_impl.dart';

part 'activity_repository_provider.g.dart';

@Riverpod(keepAlive: true)
ActivityRepository activityRepository(Ref ref) {
  return ActivityRepositoryImpl(
    remote: ActivityRemoteDataSourceImpl(ref.watch(dioClientProvider)),
  );
}
