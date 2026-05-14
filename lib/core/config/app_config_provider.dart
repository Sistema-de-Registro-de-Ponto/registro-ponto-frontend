import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'app_config.dart';

part 'app_config_provider.g.dart';

@Riverpod(keepAlive: true)
AppConfig appConfig(Ref ref) => AppConfig.fromEnvironment();
