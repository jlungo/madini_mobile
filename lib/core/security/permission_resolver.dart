/// Maps Keycloak roles/claims to PBAC permission strings (plan §4.3 Option B).
class PermissionResolver {
  /// Known role → permissions mapping. Extend as modules are added.
  static const Map<String, List<String>> _roleToPermissions = {
    'admin': ['*:*:*:any'],
    'lab_user': ['lab:sample:list', 'lab:sample:view'],
    'museum_user': ['museum:specimen:list', 'museum:specimen:view'],
    'billing_user': ['billing:gepg_bill:list', 'billing:gepg_bill:view'],
    'survey_user': ['survey:fieldwork:list', 'survey:fieldwork:view'],
  };

  /// Derive PBAC strings from roles. If [permissionsFromToken] is non-empty, merge (token wins).
  static List<String> resolve({
    required List<String> roles,
    List<String> permissionsFromToken = const [],
  }) {
    if (permissionsFromToken.isNotEmpty) {
      final set = {...permissionsFromToken};
      for (final role in roles) {
        set.addAll(_roleToPermissions[role.toLowerCase()] ?? []);
      }
      return set.toList();
    }
    final set = <String>{};
    for (final role in roles) {
      set.addAll(_roleToPermissions[role.toLowerCase()] ?? []);
    }
    return set.toList();
  }
}
