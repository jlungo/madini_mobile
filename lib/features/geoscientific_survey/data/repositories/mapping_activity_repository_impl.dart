import '../datasources/mapping_activity_remote_datasource.dart';
import '../models/mapping_activity_model.dart';

/// Data-layer implementation of mapping activity repository.
/// Delegates to remote datasource (mock or API). Will implement domain
/// repository interface when domain layer is added.
class MappingActivityRepositoryImpl {
  final MappingActivityRemoteDataSource _remoteDataSource;

  MappingActivityRepositoryImpl({
    MappingActivityRemoteDataSource? remoteDataSource,
  }) : _remoteDataSource = remoteDataSource ?? MappingActivityRemoteDataSourceImpl();

  Future<List<MappingActivityModel>> getActivities() =>
      _remoteDataSource.getActivities();

  Future<MappingActivityModel?> getActivityById(String id) =>
      _remoteDataSource.getActivityById(id);

  Future<MappingActivityModel> createActivity(MappingActivityModel activity) =>
      _remoteDataSource.createActivity(activity);

  Future<MappingActivityModel> updateActivity(String id, MappingActivityModel activity) =>
      _remoteDataSource.updateActivity(id, activity);

  Future<void> deleteActivity(String id) =>
      _remoteDataSource.deleteActivity(id);
}
