import 'permissions.dart';

/// Maps Keycloak roles to PBAC permission strings aligned with [Permissions.csv].
/// When the token has no explicit permissions, these role mappings are used.
class PermissionResolver {
  /// Role → permissions (CSV-aligned). Keys match backend roles (lowercased).
  /// Admin is super admin: gets [kPermissionWildcard] (*:*:*:any).
  /// Geologist gets all geoscientific-survey permissions (CSV 54–99).
  static const Map<String, List<String>> _roleToPermissions = {
    'admin': [kPermissionWildcard],
    'billing-officer': [
      'centralized-billing:bill:list',
      'centralized-billing:bill:view:any',
      'centralized-billing:bill:view:own',
      'centralized-billing:payment:list',
      'centralized-billing:payment:view:any',
      'centralized-billing:payment:view:own',
      'centralized-billing:dashboard:view',
    ],
    'datashop-user': [
      'datashop:material:list',
      'datashop:material:view:any',
      'datashop:order:list',
      'datashop:order:view:any',
      'datashop:order:view:own',
      'datashop:dashboard:view',
    ],
    'geologist': GeosurveyPermissions.all,
    'lab-manager': [
      LabPermissions.sampleList,
      LabPermissions.sampleViewAny,
      LabPermissions.sampleViewOwn,
      LabPermissions.sampleCreate,
      LabPermissions.sampleUpdateAny,
      LabPermissions.sampleUpdateOwn,
      LabPermissions.sampleDeleteAny,
      LabPermissions.sampleExport,
      LabPermissions.sampleImport,
    ],
    'lab-technician': [
      LabPermissions.sampleList,
      LabPermissions.sampleViewAny,
      LabPermissions.sampleViewOwn,
      LabPermissions.sampleCreate,
      LabPermissions.sampleUpdateOwn,
      LabPermissions.sampleDeleteOwn,
    ],
    'librarian': [],
    'multi-user': [],
    'museum_curator': [
      'museum:specimen:list',
      'museum:specimen:view:any',
      'museum:specimen:view:own',
      'museum:specimen:create',
      'museum:specimen:update:any',
      'museum:specimen:update:own',
      'museum:specimen:delete:any',
      'museum:specimen:delete:own',
      'museum:specimen:transfer:any',
      'museum:specimen:transfer:own',
      'museum:core-shed:list',
      'museum:core-shed:view:any',
      'museum:core-shed:view:own',
      'museum:core-shed:create',
      'museum:core-shed:update:any',
      'museum:core-shed:update:own',
      'museum:core-shed:delete:any',
      'museum:borrowing:list',
      'museum:borrowing:view:any',
      'museum:borrowing:view:own',
      'museum:borrowing:create',
      'museum:receiving:list',
      'museum:receiving:view:any',
      'museum:receiving:create',
      'museum:receiving:update:any',
      'museum:visitation:list',
      'museum:visitation:view:any',
      'museum:visitation:view:own',
      'museum:visitation:create',
    ],
  };

  /// Derive PBAC strings from roles and token.
  /// - [permissionsFromToken]: permissions from token (e.g. permissions claim).
  /// - [roles]: role names (e.g. "geologist") and/or permission strings (e.g. from
  ///   Keycloak resource roles like "geoscientific-survey:data:view:any"). Any role
  ///   containing ":" is treated as a permission and added directly.
  static List<String> resolve({
    required List<String> roles,
    List<String> permissionsFromToken = const [],
  }) {
    final set = <String>{...permissionsFromToken};
    for (final role in roles) {
      if (role.contains(':')) {
        set.add(role);
      } else {
        set.addAll(_roleToPermissions[role.toLowerCase()] ?? []);
      }
    }
    return set.toList();
  }
}
