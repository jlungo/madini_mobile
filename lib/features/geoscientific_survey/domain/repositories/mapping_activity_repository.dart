import '../entities/mapping_activity_entity.dart';

/// Repository contract for mapping activities.
/// Callers (use cases / controllers) must ensure the user is authenticated
/// and authorized; auth is enforced at API layer when using real backend.
abstract class MappingActivityRepository {
  Future<List<MappingActivityEntity>> getActivities();
  Future<MappingActivityEntity?> getActivityById(String id);
  Future<MappingActivityEntity> createActivity(MappingActivityEntity activity);
  Future<MappingActivityEntity> updateActivity(String id, MappingActivityEntity activity);
  Future<void> deleteActivity(String id);
}
