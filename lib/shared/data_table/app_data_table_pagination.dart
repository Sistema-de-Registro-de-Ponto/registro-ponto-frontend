import 'package:flutter/material.dart';

class AppDataTablePagination extends StatelessWidget {
  static const defaultPageSizeOptions = [10, 25, 50];

  final int page;
  final int pageSize;
  final int totalElements;
  final List<int> pageSizeOptions;
  final ValueChanged<int> onPageChanged;
  final ValueChanged<int> onPageSizeChanged;

  const AppDataTablePagination({
    super.key,
    required this.page,
    required this.pageSize,
    required this.totalElements,
    required this.onPageChanged,
    required this.onPageSizeChanged,
    this.pageSizeOptions = defaultPageSizeOptions,
  });

  int get _rangeStart =>
      totalElements == 0 ? 0 : (page * pageSize) + 1;

  int get _rangeEnd {
    if (totalElements == 0) return 0;

    final end = (page + 1) * pageSize;
    return end > totalElements ? totalElements : end;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final canGoBack = page > 0;
    final canGoForward = totalElements > 0 && _rangeEnd < totalElements;

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 16,
        runSpacing: 12,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Linhas por página',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: 8),
              DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  value: pageSizeOptions.contains(pageSize)
                      ? pageSize
                      : pageSizeOptions.first,
                  items: pageSizeOptions
                      .map(
                        (size) => DropdownMenuItem<int>(
                          value: size,
                          child: Text('$size'),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value == null) return;
                    onPageSizeChanged(value);
                  },
                ),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                totalElements == 0
                    ? '0 de 0'
                    : '$_rangeStart–$_rangeEnd de $totalElements',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              IconButton(
                onPressed: canGoBack ? () => onPageChanged(page - 1) : null,
                icon: const Icon(Icons.chevron_left),
                tooltip: 'Página anterior',
              ),
              IconButton(
                onPressed: canGoForward ? () => onPageChanged(page + 1) : null,
                icon: const Icon(Icons.chevron_right),
                tooltip: 'Próxima página',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
