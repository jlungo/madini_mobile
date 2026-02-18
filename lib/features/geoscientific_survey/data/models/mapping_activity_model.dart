/// Data model for a mapping activity. Aligns with webapp MappingActivity.
/// Optional fields support process flow: eoffice source, editorial status, final upload.
class MappingActivityModel {
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
  final String? source;
  final bool approvedByEoffice;
  final String? editorialStatus;
  final String? finalUploadDate;
  final bool deskworkCompleted;
  final String? deskworkNotes;
  final bool submittedToCartographers;
  final bool draftFinalized;

  const MappingActivityModel({
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
    this.source,
    this.approvedByEoffice = false,
    this.editorialStatus,
    this.finalUploadDate,
    this.deskworkCompleted = false,
    this.deskworkNotes,
    this.submittedToCartographers = false,
    this.draftFinalized = false,
  });

  factory MappingActivityModel.fromJson(Map<String, dynamic> json) {
    return MappingActivityModel(
      id: json['id'] as String? ?? '',
      activityName: json['activityName'] as String? ?? '',
      activityType: json['activityType'] as String? ?? 'Internal',
      surveyType: json['surveyType'] as String? ?? 'Geological',
      location: json['location'] as String? ?? '',
      status: json['status'] as String? ?? 'Planned',
      createdDate: json['createdDate'] as String? ?? '',
      completedDate: json['completedDate'] as String?,
      leadScientist: json['leadScientist'] as String? ?? '',
      samplesCollected: json['samplesCollected'] as bool? ?? false,
      basemapUploaded: json['basemapUploaded'] as bool? ?? false,
      reportsGenerated: json['reportsGenerated'] as bool? ?? false,
      source: json['source'] as String?,
      approvedByEoffice: json['approvedByEoffice'] as bool? ?? false,
      editorialStatus: json['editorialStatus'] as String?,
      finalUploadDate: json['finalUploadDate'] as String?,
      deskworkCompleted: json['deskworkCompleted'] as bool? ?? false,
      deskworkNotes: json['deskworkNotes'] as String?,
      submittedToCartographers: json['submittedToCartographers'] as bool? ?? false,
      draftFinalized: json['draftFinalized'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'activityName': activityName,
      'activityType': activityType,
      'surveyType': surveyType,
      'location': location,
      'status': status,
      'createdDate': createdDate,
      if (completedDate != null) 'completedDate': completedDate,
      'leadScientist': leadScientist,
      'samplesCollected': samplesCollected,
      'basemapUploaded': basemapUploaded,
      'reportsGenerated': reportsGenerated,
      if (source != null) 'source': source,
      if (approvedByEoffice) 'approvedByEoffice': approvedByEoffice,
      if (editorialStatus != null) 'editorialStatus': editorialStatus,
      if (finalUploadDate != null) 'finalUploadDate': finalUploadDate,
      if (deskworkCompleted) 'deskworkCompleted': deskworkCompleted,
      if (deskworkNotes != null) 'deskworkNotes': deskworkNotes,
      if (submittedToCartographers) 'submittedToCartographers': submittedToCartographers,
      if (draftFinalized) 'draftFinalized': draftFinalized,
    };
  }

  MappingActivityModel copyWith({
    String? id,
    String? activityName,
    String? activityType,
    String? surveyType,
    String? location,
    String? status,
    String? createdDate,
    String? completedDate,
    String? leadScientist,
    bool? samplesCollected,
    bool? basemapUploaded,
    bool? reportsGenerated,
    String? source,
    bool? approvedByEoffice,
    String? editorialStatus,
    String? finalUploadDate,
    bool? deskworkCompleted,
    String? deskworkNotes,
    bool? submittedToCartographers,
    bool? draftFinalized,
  }) {
    return MappingActivityModel(
      id: id ?? this.id,
      activityName: activityName ?? this.activityName,
      activityType: activityType ?? this.activityType,
      surveyType: surveyType ?? this.surveyType,
      location: location ?? this.location,
      status: status ?? this.status,
      createdDate: createdDate ?? this.createdDate,
      completedDate: completedDate ?? this.completedDate,
      leadScientist: leadScientist ?? this.leadScientist,
      samplesCollected: samplesCollected ?? this.samplesCollected,
      basemapUploaded: basemapUploaded ?? this.basemapUploaded,
      reportsGenerated: reportsGenerated ?? this.reportsGenerated,
      source: source ?? this.source,
      approvedByEoffice: approvedByEoffice ?? this.approvedByEoffice,
      editorialStatus: editorialStatus ?? this.editorialStatus,
      finalUploadDate: finalUploadDate ?? this.finalUploadDate,
      deskworkCompleted: deskworkCompleted ?? this.deskworkCompleted,
      deskworkNotes: deskworkNotes ?? this.deskworkNotes,
      submittedToCartographers: submittedToCartographers ?? this.submittedToCartographers,
      draftFinalized: draftFinalized ?? this.draftFinalized,
    );
  }
}
