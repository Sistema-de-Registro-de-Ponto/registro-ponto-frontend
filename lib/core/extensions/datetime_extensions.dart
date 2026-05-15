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
}
