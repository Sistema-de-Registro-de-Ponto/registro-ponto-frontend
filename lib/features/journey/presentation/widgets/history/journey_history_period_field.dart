import 'package:flutter/material.dart';
import 'package:registro_ponto_frontend/core/extensions/datetime_extensions.dart';

class JourneyHistoryPeriodField extends StatelessWidget {
  final DateTime startDate;
  final DateTime endDate;
  final ValueChanged<DateTimeRange> onPeriodChanged;

  const JourneyHistoryPeriodField({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.onPeriodChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () => _pickPeriod(context),
      borderRadius: BorderRadius.circular(8),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 232),
        child: InputDecorator(
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: theme.colorScheme.outlineVariant),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: theme.colorScheme.outlineVariant),
            ),
            suffixIcon: Icon(
              Icons.calendar_today_outlined,
              size: 20,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          child: Text(_periodLabel, style: theme.textTheme.bodyMedium),
        ),
      ),
    );
  }

  String get _periodLabel =>
      '${startDate.formattedShortDate} - ${endDate.formattedShortDate}';

  Future<void> _pickPeriod(BuildContext context) async {
    final picked = await showDateRangePicker(
      context: context,
      locale: const Locale('pt', 'BR'),
      initialDateRange: DateTimeRange(start: startDate, end: endDate),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked == null) return;

    onPeriodChanged(picked);
  }
}
