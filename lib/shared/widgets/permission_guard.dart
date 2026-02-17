import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';

class PermissionGuard extends StatelessWidget {
  final List<String> permissions;
  final bool requireAll;
  final Widget child;
  final Widget? fallback;

  const PermissionGuard({
    super.key,
    required this.permissions,
    this.requireAll = false,
    required this.child,
    this.fallback,
  });

  // Constructor for single permission
  PermissionGuard.single({
    super.key,
    required String permission,
    required this.child,
    this.fallback,
  })  : permissions = [permission],
        requireAll = true;

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user;

    if (user == null) {
      return fallback ?? const SizedBox.shrink();
    }

    bool allowed = false;
    if (requireAll) {
      allowed = user.hasAllPermissions(permissions);
    } else {
      allowed = user.hasAnyPermission(permissions);
    }

    return allowed ? child : (fallback ?? const SizedBox.shrink());
  }
}

// Add extension to User entity to support hasAllPermissions if needed
extension UserPermissionExtensions on Object { // Rough extension since User is in another file
  // Better to add this to User entity directly as I did earlier, but just in case
}
