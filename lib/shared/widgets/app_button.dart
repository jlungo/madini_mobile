import 'package:flutter/material.dart';

enum AppButtonVariant { primary, secondary, outline, destructive, ghost, link }

class AppButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final AppButtonVariant variant;
  final bool fullWidth;

  const AppButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.variant = AppButtonVariant.primary,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final ButtonStyle style;
    switch (variant) {
      case AppButtonVariant.primary:
        style = ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
        );
        break;
      case AppButtonVariant.secondary:
        style = ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.secondary,
          foregroundColor: theme.colorScheme.onSecondary,
        );
        break;
      case AppButtonVariant.outline:
        style = OutlinedButton.styleFrom(
          side: BorderSide(color: theme.colorScheme.outline),
        );
        break;
      case AppButtonVariant.destructive:
        style = ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.error,
          foregroundColor: theme.colorScheme.onError,
        );
        break;
      case AppButtonVariant.ghost:
      case AppButtonVariant.link:
        style = TextButton.styleFrom(
          foregroundColor: theme.colorScheme.primary,
        );
        break;
    }

    final btn = switch (variant) {
      AppButtonVariant.primary ||
      AppButtonVariant.secondary ||
      AppButtonVariant.destructive =>
        ElevatedButton(onPressed: onPressed, style: style, child: child),
      AppButtonVariant.outline =>
        OutlinedButton(onPressed: onPressed, style: style, child: child),
      AppButtonVariant.ghost || AppButtonVariant.link =>
        TextButton(onPressed: onPressed, style: style, child: child),
    };

    if (fullWidth) {
      return SizedBox(width: double.infinity, child: btn);
    }
    return btn;
  }
}

