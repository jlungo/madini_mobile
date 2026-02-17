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
    final roles = (json['realm_access']?['roles'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [];
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
