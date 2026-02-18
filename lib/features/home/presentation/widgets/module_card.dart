import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/module_config.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/app_card.dart';

class ModuleCard extends StatelessWidget {
  final ModuleConfig module;

  const ModuleCard({
    super.key,
    required this.module,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onCard = theme.extension<AppThemeExtension>()?.onCard ??
        theme.colorScheme.onSurface;
    final onCardMuted = theme.extension<AppThemeExtension>()?.onCardMuted ??
        theme.colorScheme.onSurface.withValues(alpha: 0.7);

    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () => context.go(module.route),
      child: AppCard(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              module.icon,
              size: 40,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              module.title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: onCard,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              module.description,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(color: onCardMuted),
            ),
          ],
        ),
      ),
    );
  }
}

