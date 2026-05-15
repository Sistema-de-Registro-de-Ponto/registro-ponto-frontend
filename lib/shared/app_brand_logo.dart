import 'package:flutter/material.dart';

class AppBrandLogo extends StatelessWidget {
  final bool compact;
  final double? iconSize;

  const AppBrandLogo({super.key, this.compact = false, this.iconSize});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = iconSize ?? (compact ? 36.0 : 44.0);
    final titleStyle = (compact ? theme.textTheme.titleMedium : theme.textTheme.titleLarge);

    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipOval(
            child: Image.asset(
              'assets/brand/app_brand_icon.png',
              width: size,
              height: size,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => _FallbackIcon(size: size, color: theme.colorScheme.primary),
            ),
          ),
          SizedBox(width: compact ? 10 : 12),
          Text(
            'Registro de Ponto',
            style: titleStyle?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
              letterSpacing: -0.25,
            ),
          ),
        ],
      ),
    );
  }
}

class _FallbackIcon extends StatelessWidget {
  final double size;
  final Color color;

  const _FallbackIcon({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: Icon(Icons.schedule_rounded, color: Colors.white, size: size * 0.55),
    );
  }
}
