import 'package:intl/intl.dart';

extension DateTimeExtensions on DateTime {
  String get formattedLongDate {
    final raw = DateFormat("EEEE, d 'de' MMMM 'de' y", 'pt_BR').format(this);

    if (raw.isEmpty) return raw;

    return raw[0].toUpperCase() + raw.substring(1);
  }

  String get formattedGreeting {
    if (hour < 12) return 'Bom dia';
    if (hour < 18) return 'Boa tarde';

    return 'Boa noite';
  }

  String get formattedHour {
    return DateFormat('HH:mm:ss').format(this);
  }

  String get formattedHourShort {
    final local = isUtc ? toLocal() : this;
    return DateFormat('HH:mm').format(local);
  }

  Duration elapsedSince(DateTime from) {
    final start = from.isUtc ? from.toLocal() : from;
    final end = isUtc ? toLocal() : this;
    return end.difference(start);
  }
}

extension DurationExtensions on Duration {
  String get formattedHms {
    final hours = inHours;
    final minutes = inMinutes.remainder(60);
    final seconds = inSeconds.remainder(60);
    final h = hours.toString().padLeft(2, '0');
    final m = minutes.toString().padLeft(2, '0');
    final s = seconds.toString().padLeft(2, '0');
    return '$h:$m:$s';
  }
}
