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
    // Note: Adjust according to actual Keycloak token structure or userinfo endpoint
    // This assumes a standard OIDC userinfo or ID token payload, PLUS custom claims for permissions
    
    return UserModel(
      id: json['sub'] ?? '',
      username: json['preferred_username'] ?? '',
      email: json['email'] ?? '',
      firstName: json['given_name'] ?? '',
      lastName: json['family_name'] ?? '',
      roles: (json['realm_access']?['roles'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      // Assuming permissions are passed in a custom claim, commonly in 'resource_access' or a simplified 'permissions' claim
      // For now, we'll assume a flat list given the web app's simplicity in 'auth.ts'
      permissions: (json['permissions'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
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
