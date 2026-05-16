import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'splash_min_display_duration.g.dart';

@Riverpod(keepAlive: true)
Duration splashMinDisplayDuration(Ref ref) => const Duration(seconds: 2);
