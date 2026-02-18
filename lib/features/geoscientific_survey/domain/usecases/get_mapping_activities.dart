import '../entities/mapping_activity_entity.dart';
import '../repositories/mapping_activity_repository.dart';

/// Fetches all mapping activities. Caller must ensure user is authenticated/authorized.
class GetMappingActivities {
  final MappingActivityRepository _repository;

  const GetMappingActivities(this._repository);

  Future<List<MappingActivityEntity>> call() => _repository.getActivities();
}
