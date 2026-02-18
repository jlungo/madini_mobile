import '../entities/mapping_activity_entity.dart';
import '../repositories/mapping_activity_repository.dart';

/// Creates a mapping activity. Caller must ensure user is authenticated/authorized.
class CreateMappingActivity {
  final MappingActivityRepository _repository;

  const CreateMappingActivity(this._repository);

  Future<MappingActivityEntity> call(MappingActivityEntity activity) =>
      _repository.createActivity(activity);
}
