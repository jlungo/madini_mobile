/// Super-admin permission string: grants all permissions.
const String kSuperAdminPermission = '*:*:*:any';

class User {
  final String id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final List<String> roles;
  final List<String> permissions;

  const User({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.roles,
    required this.permissions,
  });

  /// True when this user is super admin (admin role or *:*:*:any permission).
  bool get isSuperAdmin =>
      roles.any((r) => r.toLowerCase() == 'admin') ||
      permissions.contains('*') ||
      permissions.contains(kSuperAdminPermission);

  bool hasPermission(String permission) {
    if (isSuperAdmin) return true;
    return permissions.contains(permission);
  }

  bool hasAnyPermission(List<String> requiredPermissions) {
    if (isSuperAdmin) return true;
    return requiredPermissions.any((p) => permissions.contains(p));
  }

  bool hasAllPermissions(List<String> requiredPermissions) {
    if (isSuperAdmin) return true;
    return requiredPermissions.every((p) => permissions.contains(p));
  }
}
