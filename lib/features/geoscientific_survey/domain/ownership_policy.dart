import '../../auth/domain/entities/user.dart';
import 'entities/mapping_activity_entity.dart';

/// Default policy instance. Replace with a strict implementation when
/// [MappingActivityEntity] has ownerId/createdBy/assignedTo from the backend.
const MappingActivityOwnershipPolicy kDefaultMappingActivityOwnershipPolicy =
    PermissiveMappingActivityOwnershipPolicy();

/// Determines if a [User] is considered the owner of a [MappingActivityEntity].
/// Used when the user has `:own` scope but not `:any` (e.g. view:own, update:own).
///
/// Until the backend provides explicit ownership fields (e.g. [MappingActivityEntity.ownerId],
/// [createdBy], or [assignedTo]), use [PermissiveMappingActivityOwnershipPolicy],
/// which allows access when ownership cannot be determined.
abstract class MappingActivityOwnershipPolicy {
  bool isOwner(User user, MappingActivityEntity activity);
}

/// Permissive implementation: returns [true] when ownership cannot be determined.
///
/// Use this until [MappingActivityEntity] (or API) includes owner identifiers
/// (e.g. ownerId, createdBy, assignedTo). Then replace with an implementation
/// that checks e.g. [activity.ownerId == user.id] or matches lead scientist to user.
class PermissiveMappingActivityOwnershipPolicy
    implements MappingActivityOwnershipPolicy {
  const PermissiveMappingActivityOwnershipPolicy();

  @override
  bool isOwner(User user, MappingActivityEntity activity) {
    // No ownerId/createdBy on entity yet → allow to avoid blocking :own users.
    return true;
  }
}

/// Returns whether [user] may perform an action on [activity] when the action
/// is gated by an "any" or "own" permission. Use when enforcing view/update
/// per-activity (e.g. list row or detail page). Pass [anyPermission] and
/// [ownPermission] from [GeosurveyPermissions] (e.g. view:any, view:own).
bool canActOnMappingActivity(
  User user,
  MappingActivityEntity activity,
  MappingActivityOwnershipPolicy policy, {
  required String anyPermission,
  required String ownPermission,
}) {
  if (user.hasPermission(anyPermission)) return true;
  if (user.hasPermission(ownPermission)) return policy.isOwner(user, activity);
  return false;
}
