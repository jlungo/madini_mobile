import '../../../../core/security/permission_resolver.dart';
import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.username,
    required super.email,
    required super.firstName,
    required super.lastName,
    required super.roles,
    required super.permissions,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final roles = _collectRoles(json);
    final fromToken =
        (json['permissions'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];
    final permissions = PermissionResolver.resolve(
      roles: roles,
      permissionsFromToken: fromToken,
    );
    return UserModel(
      id: json['sub'] ?? '',
      username: json['preferred_username'] ?? '',
      email: json['email'] ?? '',
      firstName: json['given_name'] ?? '',
      lastName: json['family_name'] ?? '',
      roles: roles,
      permissions: permissions,
    );
  }

  /// Collects role names (and permission-like strings) from token payload.
  /// Reads realm_access.roles, top-level "roles", and resource_access.<client>.roles
  /// so backend can send roles in any of these.
  static List<String> _collectRoles(Map<String, dynamic> json) {
    final list = <String>[];
    final realmRoles = json['realm_access']?['roles'] as List<dynamic>?;
    if (realmRoles != null) {
      list.addAll(realmRoles.map((e) => e.toString()));
    }
    final topRoles = json['roles'] as List<dynamic>?;
    if (topRoles != null) {
      list.addAll(topRoles.map((e) => e.toString()));
    }
    final resourceAccess = json['resource_access'] as Map<String, dynamic>?;
    if (resourceAccess != null) {
      for (final clientRoles in resourceAccess.values) {
        if (clientRoles is Map && clientRoles['roles'] is List) {
          list.addAll((clientRoles['roles'] as List).map((e) => e.toString()));
        }
      }
    }
    return list;
  }

  Map<String, dynamic> toJson() {
    return {
      'sub': id,
      'preferred_username': username,
      'email': email,
      'given_name': firstName,
      'family_name': lastName,
      'realm_access': {
        'roles': roles,
      },
      'permissions': permissions,
    };
  }
}
