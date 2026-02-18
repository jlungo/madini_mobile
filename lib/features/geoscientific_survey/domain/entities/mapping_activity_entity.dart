/// Domain entity for a mapping activity. No serialization; used by domain and presentation.
class MappingActivityEntity {
  final String id;
  final String activityName;
  final String activityType;
  final String surveyType;
  final String location;
  final String status;
  final String createdDate;
  final String? completedDate;
  final String leadScientist;
  final bool samplesCollected;
  final bool basemapUploaded;
  final bool reportsGenerated;

  const MappingActivityEntity({
    required this.id,
    required this.activityName,
    required this.activityType,
    required this.surveyType,
    required this.location,
    required this.status,
    required this.createdDate,
    this.completedDate,
    required this.leadScientist,
    required this.samplesCollected,
    required this.basemapUploaded,
    required this.reportsGenerated,
  });
}
