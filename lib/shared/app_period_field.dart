import 'package:flutter/material.dart';
import 'package:registro_ponto_frontend/core/extensions/datetime_extensions.dart';
import 'package:registro_ponto_frontend/shared/app_responsive.dart';

class AppPeriodField extends StatelessWidget {
  final DateTime startDate;
  final DateTime endDate;
  final ValueChanged<DateTimeRange> onPeriodChanged;

  const AppPeriodField({
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
      helpText: 'Selecione o intervalo',
      initialDateRange: DateTimeRange(start: startDate, end: endDate),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialEntryMode: DatePickerEntryMode.calendar,
      builder: (context, child) {
        final content = Theme(
          data: Theme.of(context),
          child: child ?? const SizedBox.shrink(),
        );

        return AppResponsive(
          desktopBreakpoint: 600,
          mobile: content,
          desktop: MediaQuery(
            data: MediaQuery.of(context).copyWith(size: Size(400, 520)),
            child: content,
          ),
        );
      },
    );

    if (picked == null) return;

    onPeriodChanged(picked);
  }
}
