import '../repositories/mapping_activity_repository.dart';

/// Deletes a mapping activity. Caller must ensure user is authenticated/authorized.
class DeleteMappingActivity {
  final MappingActivityRepository _repository;

  const DeleteMappingActivity(this._repository);

  Future<void> call(String id) => _repository.deleteActivity(id);
}
