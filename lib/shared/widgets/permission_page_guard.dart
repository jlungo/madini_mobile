import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../features/auth/presentation/providers/auth_provider.dart';
import 'app_scaffold.dart';

/// Wraps a page and shows [child] only if the user has any of [requiredAnyPermissions].
/// On unauthorized, shows [fallback] or a minimal "Not authorized" message (no redirect).
class PermissionPageGuard extends StatelessWidget {
  const PermissionPageGuard({
    super.key,
    required this.requiredAnyPermissions,
    required this.child,
    this.fallback,
  });

  /// User must have at least one of these permissions to see [child].
  final List<String> requiredAnyPermissions;

  final Widget child;

  /// Shown when user lacks permission. Defaults to a minimal scaffold with message.
  final Widget? fallback;

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    final allowed = user != null &&
        (requiredAnyPermissions.isEmpty ||
            user.hasAnyPermission(requiredAnyPermissions));

    if (allowed) return child;
    return fallback ?? _defaultFallback(context);
  }

  static Widget _defaultFallback(BuildContext context) {
    return AppScaffold(
      title: 'Access restricted',
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            "You don't have permission to view this page.",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                ),
          ),
        ),
      ),
    );
  }
}
