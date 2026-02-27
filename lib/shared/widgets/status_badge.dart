import 'package:flutter/material.dart';

class StatusBadge extends StatelessWidget {
  final String status;
  final Color? color;

  const StatusBadge({
    super.key,
    required this.status,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final backgroundColor = color ?? _getBackgroundColor(status, theme);
    final textColor = color != null ? Colors.white : _getTextColor(status, theme);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Color _getBackgroundColor(String status, ThemeData theme) {
    final s = status.toLowerCase();
    if (s.contains('active') || s.contains('economic') || s.contains('high') || s.contains('feasible')) {
      return Colors.green.withOpacity(0.1);
    }
    if (s.contains('study') || s.contains('preliminary') || s.contains('potential') || s.contains('medium')) {
      return Colors.orange.withOpacity(0.1);
    }
    if (s.contains('inactive') || s.contains('sub-economic') || s.contains('low') || s.contains('not feasible')) {
      return Colors.red.withOpacity(0.1);
    }
    return theme.colorScheme.surfaceVariant;
  }

  Color _getTextColor(String status, ThemeData theme) {
    final s = status.toLowerCase();
    if (s.contains('active') || s.contains('economic') || s.contains('high') || s.contains('feasible')) {
      return Colors.green[700]!;
    }
    if (s.contains('study') || s.contains('preliminary') || s.contains('potential') || s.contains('medium')) {
      return Colors.orange[700]!;
    }
    if (s.contains('inactive') || s.contains('sub-economic') || s.contains('low') || s.contains('not feasible')) {
      return Colors.red[700]!;
    }
    return theme.colorScheme.onSurfaceVariant;
  }
}
