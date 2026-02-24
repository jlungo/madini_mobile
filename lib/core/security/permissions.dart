/// Centralized PBAC permission strings aligned with [Permissions.csv].
/// Use these constants instead of hardcoding strings so changes stay in one place.
// ---------------------------------------------------------------------------
// Wildcard (super admin)
// ---------------------------------------------------------------------------

/// Super-admin: grants all permissions.
const String kPermissionWildcard = '*:*:*:any';

// ---------------------------------------------------------------------------
// Geoscientific Survey module (Permissions.csv)
// ---------------------------------------------------------------------------

abstract final class GeosurveyPermissions {
  GeosurveyPermissions._();

  static const String _module = 'geoscientific-survey';

  // --- mapping-activity ---
  static const String mappingActivityList = '$_module:mapping-activity:list';
  static const String mappingActivityViewAny = '$_module:mapping-activity:view:any';
  static const String mappingActivityViewOwn = '$_module:mapping-activity:view:own';
  static const String mappingActivityCreate = '$_module:mapping-activity:create';
  static const String mappingActivityUpdateAny = '$_module:mapping-activity:update:any';
  static const String mappingActivityUpdateOwn = '$_module:mapping-activity:update:own';
  static const String mappingActivityDeleteAny = '$_module:mapping-activity:delete:any';

  /// For guards that accept either view:any or view:own.
  static const List<String> mappingActivityView = [mappingActivityViewAny, mappingActivityViewOwn];

  /// For guards that accept either update:any or update:own.
  static const List<String> mappingActivityUpdate = [mappingActivityUpdateAny, mappingActivityUpdateOwn];

  // --- drawer sections (list / view) ---
  static const String depositList = '$_module:deposit:list';
  static const String mineList = '$_module:mine:list';
  static const String drillHoleList = '$_module:drill-hole:list';
  static const String geochemistryList = '$_module:geochemistry:list';
  static const String reportList = '$_module:report:list';
  static const String reportCreate = '$_module:report:create';
  static const String reportUpdateAny = '$_module:report:update:any';
  static const String reportUpdateOwn = '$_module:report:update:own';
  static const String locationList = '$_module:location:list';
  static const String mapViewerView = '$_module:map-viewer:view';

  /// All geoscientific-survey permissions (CSV lines 54–99). Use for geologist role.
  static const List<String> all = [
    mappingActivityList,
    mappingActivityViewAny,
    mappingActivityViewOwn,
    mappingActivityCreate,
    mappingActivityUpdateAny,
    mappingActivityUpdateOwn,
    mappingActivityDeleteAny,
    '$_module:drill-hole:list',
    '$_module:drill-hole:view:any',
    '$_module:drill-hole:view:own',
    '$_module:drill-hole:create',
    '$_module:drill-hole:update:any',
    '$_module:drill-hole:update:own',
    '$_module:drill-hole:delete:any',
    depositList,
    '$_module:deposit:view:any',
    '$_module:deposit:view:own',
    '$_module:deposit:create',
    '$_module:deposit:update:any',
    '$_module:deposit:update:own',
    '$_module:deposit:delete:any',
    mineList,
    '$_module:mine:view:any',
    '$_module:mine:view:own',
    '$_module:mine:create',
    '$_module:mine:update:any',
    '$_module:mine:update:own',
    '$_module:mine:delete:any',
    locationList,
    '$_module:location:view:any',
    '$_module:location:create',
    '$_module:location:update:any',
    '$_module:location:delete:any',
    geochemistryList,
    '$_module:geochemistry:view:any',
    '$_module:geochemistry:create',
    '$_module:geochemistry:update:any',
    '$_module:geochemistry:delete:any',
    reportList,
    '$_module:report:view:any',
    '$_module:report:view:own',
    reportCreate,
    reportUpdateAny,
    reportUpdateOwn,
    '$_module:report:delete:any',
    mapViewerView,
  ];
}

// ---------------------------------------------------------------------------
// Lab module (Permissions.csv)
// ---------------------------------------------------------------------------

abstract final class LabPermissions {
  LabPermissions._();

  static const String _module = 'lab';

  static const String sampleList = '$_module:sample:list';
  static const String sampleViewAny = '$_module:sample:view:any';
  static const String sampleViewOwn = '$_module:sample:view:own';
  static const String sampleCreate = '$_module:sample:create';
  static const String sampleUpdateAny = '$_module:sample:update:any';
  static const String sampleUpdateOwn = '$_module:sample:update:own';
  static const String sampleDeleteAny = '$_module:sample:delete:any';
  static const String sampleDeleteOwn = '$_module:sample:delete:own';
  static const String sampleExport = '$_module:sample:export';
  static const String sampleImport = '$_module:sample:import';

  /// For guards that accept either view:any or view:own.
  static const List<String> sampleView = [sampleViewAny, sampleViewOwn];
}
