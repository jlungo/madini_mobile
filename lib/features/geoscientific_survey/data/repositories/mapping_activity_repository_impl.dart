import '../../domain/entities/mapping_activity_entity.dart';
import '../../domain/repositories/mapping_activity_repository.dart';
import '../datasources/mapping_activity_remote_datasource.dart';
import '../models/mapping_activity_model.dart';

/// Data-layer implementation of mapping activity repository.
/// Delegates to remote datasource (mock or API); auth is applied at API layer.
class MappingActivityRepositoryImpl implements MappingActivityRepository {
  final MappingActivityRemoteDataSource _remoteDataSource;

  MappingActivityRepositoryImpl({
    MappingActivityRemoteDataSource? remoteDataSource,
  }) : _remoteDataSource = remoteDataSource ?? MappingActivityRemoteDataSourceImpl();

  static MappingActivityEntity _toEntity(MappingActivityModel m) {
    return MappingActivityEntity(
      id: m.id,
      activityName: m.activityName,
      activityType: m.activityType,
      surveyType: m.surveyType,
      location: m.location,
      status: m.status,
      createdDate: m.createdDate,
      completedDate: m.completedDate,
      leadScientist: m.leadScientist,
      samplesCollected: m.samplesCollected,
      basemapUploaded: m.basemapUploaded,
      reportsGenerated: m.reportsGenerated,
      source: m.source,
      approvedByEoffice: m.approvedByEoffice,
      editorialStatus: m.editorialStatus,
      finalUploadDate: m.finalUploadDate,
      deskworkCompleted: m.deskworkCompleted,
      deskworkNotes: m.deskworkNotes,
      submittedToCartographers: m.submittedToCartographers,
      draftFinalized: m.draftFinalized,
    );
  }

  static MappingActivityModel _toModel(MappingActivityEntity e) {
    return MappingActivityModel(
      id: e.id,
      activityName: e.activityName,
      activityType: e.activityType,
      surveyType: e.surveyType,
      location: e.location,
      status: e.status,
      createdDate: e.createdDate,
      completedDate: e.completedDate,
      leadScientist: e.leadScientist,
      samplesCollected: e.samplesCollected,
      basemapUploaded: e.basemapUploaded,
      reportsGenerated: e.reportsGenerated,
      source: e.source,
      approvedByEoffice: e.approvedByEoffice,
      editorialStatus: e.editorialStatus,
      finalUploadDate: e.finalUploadDate,
      deskworkCompleted: e.deskworkCompleted,
      deskworkNotes: e.deskworkNotes,
      submittedToCartographers: e.submittedToCartographers,
      draftFinalized: e.draftFinalized,
    );
  }

  @override
  Future<List<MappingActivityEntity>> getActivities() async {
    final list = await _remoteDataSource.getActivities();
    return list.map(_toEntity).toList();
  }

  @override
  Future<MappingActivityEntity?> getActivityById(String id) async {
    final model = await _remoteDataSource.getActivityById(id);
    return model != null ? _toEntity(model) : null;
  }

  @override
  Future<MappingActivityEntity> createActivity(MappingActivityEntity activity) async {
    final model = await _remoteDataSource.createActivity(_toModel(activity));
    return _toEntity(model);
  }

  @override
  Future<MappingActivityEntity> updateActivity(String id, MappingActivityEntity activity) async {
    final model = await _remoteDataSource.updateActivity(id, _toModel(activity));
    return _toEntity(model);
  }

  @override
  Future<void> deleteActivity(String id) async {
    await _remoteDataSource.deleteActivity(id);
  }

  @override
  Future<void> submitPreserveSpecimens(
    String activityId, {
    required int specimenCount,
    required String specimenType,
    required String destination,
    String? notes,
  }) async {
    // No-op until backend endpoint exists; API layer will enforce auth.
  }
}
