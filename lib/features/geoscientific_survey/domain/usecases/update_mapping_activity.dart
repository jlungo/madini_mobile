import '../entities/mapping_activity_entity.dart';
import '../repositories/mapping_activity_repository.dart';

/// Updates a mapping activity. Caller must ensure user is authenticated/authorized.
class UpdateMappingActivity {
  final MappingActivityRepository _repository;

  const UpdateMappingActivity(this._repository);

  Future<MappingActivityEntity> call(String id, MappingActivityEntity activity) =>
      _repository.updateActivity(id, activity);
}
