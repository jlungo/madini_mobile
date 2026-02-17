/// PBAC permission value object: module:resource:action[:scope] (plan §4.3).
class Permission {
  final String module;
  final String resource;
  final String action;
  final String? scope;

  const Permission({
    required this.module,
    required this.resource,
    required this.action,
    this.scope,
  });

  /// Parse from string e.g. "billing:gepg_bill:create:any".
  static Permission? tryParse(String raw) {
    final parts = raw.split(':');
    if (parts.length < 3) return null;
    return Permission(
      module: parts[0],
      resource: parts[1],
      action: parts[2],
      scope: parts.length > 3 ? parts[3] : null,
    );
  }

  String get raw => scope != null
      ? '$module:$resource:$action:$scope'
      : '$module:$resource:$action';
}
