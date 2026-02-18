import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Placeholder for geosurvey sections not yet implemented (Deposits, Mines, etc.).
/// Used as shell child; auth enforced by route guard.
class GeosurveyPlaceholderPage extends StatelessWidget {
  const GeosurveyPlaceholderPage({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.construction_outlined,
              size: 64,
              color: theme.colorScheme.primary.withValues(alpha: 0.6),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Coming soon',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => context.go('/geoscientific-survey/mapping-activity'),
              icon: const Icon(Icons.list_alt, size: 20),
              label: const Text('Back to Mapping Activity'),
            ),
          ],
        ),
      ),
    );
  }
}
