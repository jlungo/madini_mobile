import '../models/mapping_activity_model.dart';

/// Remote data source for mapping activities.
/// Implementations may use API client or mock data until backend is ready.
abstract class MappingActivityRemoteDataSource {
  Future<List<MappingActivityModel>> getActivities();
  Future<MappingActivityModel?> getActivityById(String id);
  Future<MappingActivityModel> createActivity(MappingActivityModel activity);
  Future<MappingActivityModel> updateActivity(String id, MappingActivityModel activity);
  Future<void> deleteActivity(String id);
}

/// Mock implementation using in-memory list aligned with webapp mockData.
class MappingActivityRemoteDataSourceImpl implements MappingActivityRemoteDataSource {
  List<MappingActivityModel> _activities = _mockActivities();

  static List<MappingActivityModel> _mockActivities() {
    return [
      const MappingActivityModel(
        id: 'MAP-2024-001',
        activityName: 'Geita Gold Belt Geological Mapping',
        activityType: 'Internal',
        surveyType: 'Geological',
        location: 'Geita Region',
        status: 'Completed',
        createdDate: '2024-01-15',
        completedDate: '2024-03-20',
        leadScientist: 'Dr. John Makundi',
        samplesCollected: true,
        basemapUploaded: true,
        reportsGenerated: true,
      ),
      const MappingActivityModel(
        id: 'MAP-2024-002',
        activityName: 'Mererani Tanzanite Zone Mapping',
        activityType: 'Consultancy',
        surveyType: 'Geological',
        location: 'Mererani, Arusha',
        status: 'Map & Report Preparation',
        createdDate: '2024-02-10',
        leadScientist: 'Dr. Sarah Mtui',
        samplesCollected: true,
        basemapUploaded: true,
        reportsGenerated: false,
      ),
      const MappingActivityModel(
        id: 'MAP-2024-003',
        activityName: 'Lake Victoria Geochemical Survey',
        activityType: 'Internal',
        surveyType: 'Geochemical',
        location: 'Lake Victoria Basin',
        status: 'Awaiting Lab Results',
        createdDate: '2024-03-05',
        leadScientist: 'Dr. Peter Kamwela',
        samplesCollected: true,
        basemapUploaded: true,
        reportsGenerated: false,
      ),
      const MappingActivityModel(
        id: 'MAP-2024-004',
        activityName: 'Dodoma Geohazard Assessment',
        activityType: 'Internal',
        surveyType: 'Geohazard',
        location: 'Dodoma Region',
        status: 'On-site Data Collection',
        createdDate: '2024-04-01',
        leadScientist: 'Dr. Grace Mwakilema',
        samplesCollected: false,
        basemapUploaded: true,
        reportsGenerated: false,
      ),
      const MappingActivityModel(
        id: 'MAP-2024-005',
        activityName: 'Tanga Magnetic Survey',
        activityType: 'Consultancy',
        surveyType: 'Geophysical',
        location: 'Tanga Region',
        status: 'Ready for Site Visit',
        createdDate: '2024-05-12',
        leadScientist: 'Dr. James Mbwambo',
        samplesCollected: false,
        basemapUploaded: true,
        reportsGenerated: false,
      ),
      const MappingActivityModel(
        id: 'MAP-2024-006',
        activityName: 'Kigoma Copper Belt Mapping',
        activityType: 'Internal',
        surveyType: 'Geological',
        location: 'Kigoma Region',
        status: 'Planned',
        createdDate: '2024-06-20',
        leadScientist: 'Dr. Agnes Kileo',
        samplesCollected: false,
        basemapUploaded: false,
        reportsGenerated: false,
      ),
      const MappingActivityModel(
        id: 'MAP-2024-007',
        activityName: 'Singida Rare Earth Exploration',
        activityType: 'Internal',
        surveyType: 'Geochemical',
        location: 'Singida Region',
        status: 'Lab Results Received',
        createdDate: '2024-03-18',
        leadScientist: 'Dr. Emmanuel Mwakasege',
        samplesCollected: true,
        basemapUploaded: true,
        reportsGenerated: false,
      ),
      const MappingActivityModel(
        id: 'MAP-2024-008',
        activityName: 'Kilimanjaro Seismic Study',
        activityType: 'Consultancy',
        surveyType: 'Geophysical',
        location: 'Kilimanjaro Region',
        status: 'On-site Data Collection',
        createdDate: '2024-05-25',
        leadScientist: 'Dr. Michael Simkoko',
        samplesCollected: false,
        basemapUploaded: true,
        reportsGenerated: false,
      ),
    ];
  }

  @override
  Future<List<MappingActivityModel>> getActivities() async {
    return List.from(_activities);
  }

  @override
  Future<MappingActivityModel?> getActivityById(String id) async {
    try {
      return _activities.firstWhere((a) => a.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<MappingActivityModel> createActivity(MappingActivityModel activity) async {
    final newActivity = activity.copyWith(
      id: activity.id.isEmpty ? 'MAP-2024-${(_activities.length + 1).toString().padLeft(3, '0')}' : activity.id,
    );
    _activities = [newActivity, ..._activities];
    return newActivity;
  }

  @override
  Future<MappingActivityModel> updateActivity(String id, MappingActivityModel activity) async {
    final index = _activities.indexWhere((a) => a.id == id);
    if (index < 0) throw MappingActivityDataSourceException('Activity not found: $id');
    final updated = activity.copyWith(id: id);
    _activities = List.from(_activities)..[index] = updated;
    return updated;
  }

  @override
  Future<void> deleteActivity(String id) async {
    final removed = _activities.where((a) => a.id != id).toList();
    if (removed.length == _activities.length) {
      throw MappingActivityDataSourceException('Activity not found: $id');
    }
    _activities = removed;
  }
}

class MappingActivityDataSourceException implements Exception {
  final String message;
  MappingActivityDataSourceException(this.message);
  @override
  String toString() => message;
}
