import '../entities/mapping_activity_entity.dart';
import '../repositories/mapping_activity_repository.dart';

/// Fetches a single mapping activity by id. Caller must ensure user is authenticated/authorized.
class GetMappingActivityById {
  final MappingActivityRepository _repository;

  const GetMappingActivityById(this._repository);

  Future<MappingActivityEntity?> call(String id) => _repository.getActivityById(id);
}
