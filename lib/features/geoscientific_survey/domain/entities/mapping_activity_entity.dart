/// Domain entity for a mapping activity. No serialization; used by domain and presentation.
/// Optional fields support process flow: eoffice source (step 1), editorial (step 11), final upload (step 12).
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
  /// Origin of the activity: e.g. 'eoffice' (approved from e-office) or 'internal'.
  final String? source;
  /// True when the activity was approved via eoffice (step 1).
  final bool approvedByEoffice;
  /// Editorial workflow: null | 'draft_submitted' | 'returned' | 'approved'.
  final String? editorialStatus;
  /// ISO date when final upload was completed (step 12).
  final String? finalUploadDate;
  /// Deskwork step (step 2): literature review, satellite data, spatial overlay completed.
  final bool deskworkCompleted;
  /// Optional notes for deskwork step.
  final String? deskworkNotes;
  /// Draft Map & Report: preliminary data submitted to cartographers (Case 1).
  final bool submittedToCartographers;
  /// Draft Map & Report: draft finalized incorporating lab results (step 10).
  final bool draftFinalized;

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
    this.source,
    this.approvedByEoffice = false,
    this.editorialStatus,
    this.finalUploadDate,
    this.deskworkCompleted = false,
    this.deskworkNotes,
    this.submittedToCartographers = false,
    this.draftFinalized = false,
  });

  /// Whether editorial has approved this activity (enables final upload).
  bool get isEditorialApproved => editorialStatus == 'approved';

  MappingActivityEntity copyWith({
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
    return MappingActivityEntity(
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
