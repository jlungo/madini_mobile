/// Nested entity for Associated Rocks.
class AssociatedRock {
  final String name;
  final String? stratigraphicAge;
  final String? alteration;
  final String? color;
  final String? texture;
  final String? position;
  final String? comment;

  const AssociatedRock({
    required this.name,
    this.stratigraphicAge,
    this.alteration,
    this.color,
    this.texture,
    this.position,
    this.comment,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'stratigraphicAge': stratigraphicAge,
    'alteration': alteration,
    'color': color,
    'texture': texture,
    'position': position,
    'comment': comment,
  };

  factory AssociatedRock.fromJson(Map<String, dynamic> json) => AssociatedRock(
    name: json['name'] as String,
    stratigraphicAge: json['stratigraphicAge'] as String?,
    alteration: json['alteration'] as String?,
    color: json['color'] as String?,
    texture: json['texture'] as String?,
    position: json['position'] as String?,
    comment: json['comment'] as String?,
  );
}

/// Nested entity for Mineral Detail.
class MineralDetail {
  final String mineral;
  final String? status;
  final String? comment;

  const MineralDetail({
    required this.mineral,
    this.status,
    this.comment,
  });

  Map<String, dynamic> toJson() => {
    'mineral': mineral,
    'status': status,
    'comment': comment,
  };

  factory MineralDetail.fromJson(Map<String, dynamic> json) => MineralDetail(
    mineral: json['mineral'] as String,
    status: json['status'] as String?,
    comment: json['comment'] as String?,
  );
}

/// Nested entity for Resource/Reserve Detail.
class ResourceDetail {
  final String commodity;
  final String? amountOre;
  final String? amountUnit;
  final String? grade;
  final String? gradeUnit;
  final String? content;
  final String? contentUnit;
  final String? classification;
  final String? date;
  final String? archiveReport;
  final String? name;

  const ResourceDetail({
    required this.commodity,
    this.amountOre,
    this.amountUnit,
    this.grade,
    this.gradeUnit,
    this.content,
    this.contentUnit,
    this.classification,
    this.date,
    this.archiveReport,
    this.name,
  });

  Map<String, dynamic> toJson() => {
    'commodity': commodity,
    'amountOre': amountOre,
    'amountUnit': amountUnit,
    'grade': grade,
    'gradeUnit': gradeUnit,
    'content': content,
    'contentUnit': contentUnit,
    'classification': classification,
    'date': date,
    'archiveReport': archiveReport,
    'name': name,
  };

  factory ResourceDetail.fromJson(Map<String, dynamic> json) => ResourceDetail(
    commodity: json['commodity'] as String,
    amountOre: json['amountOre'] as String?,
    amountUnit: json['amountUnit'] as String?,
    grade: json['grade'] as String?,
    gradeUnit: json['gradeUnit'] as String?,
    content: json['content'] as String?,
    contentUnit: json['contentUnit'] as String?,
    classification: json['classification'] as String?,
    date: json['date'] as String?,
    archiveReport: json['archiveReport'] as String?,
    name: json['name'] as String?,
  );
}

/// Nested entity for Work Done Detail.
class WorkDoneDetail {
  final String workDone;
  final String? startYear;
  final String? stopYear;
  final String? amount;
  final String? amountUnit;
  final String? cost;
  final String? costUnit;

  const WorkDoneDetail({
    required this.workDone,
    this.startYear,
    this.stopYear,
    this.amount,
    this.amountUnit,
    this.cost,
    this.costUnit,
  });

  Map<String, dynamic> toJson() => {
    'workDone': workDone,
    'startYear': startYear,
    'stopYear': stopYear,
    'amount': amount,
    'amountUnit': amountUnit,
    'cost': cost,
    'costUnit': costUnit,
  };

  factory WorkDoneDetail.fromJson(Map<String, dynamic> json) => WorkDoneDetail(
    workDone: json['workDone'] as String,
    startYear: json['startYear'] as String?,
    stopYear: json['stopYear'] as String?,
    amount: json['amount'] as String?,
    amountUnit: json['amountUnit'] as String?,
    cost: json['cost'] as String?,
    costUnit: json['costUnit'] as String?,
  );
}

/// Domain entity for a Geoscientific Deposit.
class DepositEntity {
  final String id;
  final String depositName;
  final String feasibility;
  final String economicStatus;
  final String geoKnowledge;

  // Header Data - Basic Information
  final String? commodityGroup;
  final String? commodity;
  final String? miningStatus;
  final String? unfcClassification;

  // Header Data - Coordinates
  final String? xUtm36s;
  final String? yUtm36s;
  final String? xWgs84;
  final String? yWgs84;

  // Location Tab
  final String? region;
  final String? district;
  final String? division;
  final String? topoSheet250k;
  final String? topoSheet100k;
  final String? topoSheet50k;
  final String? geologicalMap;
  final String? access;

  // Regional Geology Tab
  final String? geologicalDescription;
  final String? geologicalTectonic;
  final String? chronostratigraphicAge;
  final String? hostRockLithology;
  final String? regionalComment;

  // Deposit Geology Tab
  final String? generalDescription;
  final String? shape;
  final String? length;
  final String? width;
  final String? depth;
  final String? dip;
  final String? azimuth;
  final String? strike;
  final String? depositComment;

  // Mineralisation Tab
  final String? mineralisationType;
  final String? weatheringStatus;

  // Rich Lists
  final List<AssociatedRock> rocks;
  final List<MineralDetail> mineralDetails;
  final List<ResourceDetail> resourceDetails;
  final List<WorkDoneDetail> workDoneDetails;

  // Discovery Tab
  final String? discoveryMethod;
  final String? discoveryYear;
  final String? workStartYear;
  final String? stopYear;
  final String? discoveryComment;

  // Other Tabs
  final String? archiveReports;
  final String? siteComment;
  final String? recordInfo;

  const DepositEntity({
    required this.id,
    required this.depositName,
    required this.feasibility,
    required this.economicStatus,
    required this.geoKnowledge,
    this.commodityGroup,
    this.commodity,
    this.miningStatus,
    this.unfcClassification,
    this.xUtm36s,
    this.yUtm36s,
    this.xWgs84,
    this.yWgs84,
    this.region,
    this.district,
    this.division,
    this.topoSheet250k,
    this.topoSheet100k,
    this.topoSheet50k,
    this.geologicalMap,
    this.access,
    this.geologicalDescription,
    this.geologicalTectonic,
    this.chronostratigraphicAge,
    this.hostRockLithology,
    this.regionalComment,
    this.generalDescription,
    this.shape,
    this.length,
    this.width,
    this.depth,
    this.dip,
    this.azimuth,
    this.strike,
    this.depositComment,
    this.mineralisationType,
    this.weatheringStatus,
    this.rocks = const [],
    this.mineralDetails = const [],
    this.resourceDetails = const [],
    this.workDoneDetails = const [],
    this.discoveryMethod,
    this.discoveryYear,
    this.workStartYear,
    this.stopYear,
    this.discoveryComment,
    this.archiveReports,
    this.siteComment,
    this.recordInfo,
  });

  DepositEntity copyWith({
    String? id,
    String? depositName,
    String? feasibility,
    String? economicStatus,
    String? geoKnowledge,
    String? commodityGroup,
    String? commodity,
    String? miningStatus,
    String? unfcClassification,
    String? xUtm36s,
    String? yUtm36s,
    String? xWgs84,
    String? yWgs84,
    String? region,
    String? district,
    String? division,
    String? topoSheet250k,
    String? topoSheet100k,
    String? topoSheet50k,
    String? geologicalMap,
    String? access,
    String? geologicalDescription,
    String? geologicalTectonic,
    String? chronostratigraphicAge,
    String? hostRockLithology,
    String? regionalComment,
    String? generalDescription,
    String? shape,
    String? length,
    String? width,
    String? depth,
    String? dip,
    String? azimuth,
    String? strike,
    String? depositComment,
    String? mineralisationType,
    String? weatheringStatus,
    List<AssociatedRock>? rocks,
    List<MineralDetail>? mineralDetails,
    List<ResourceDetail>? resourceDetails,
    List<WorkDoneDetail>? workDoneDetails,
    String? discoveryMethod,
    String? discoveryYear,
    String? workStartYear,
    String? stopYear,
    String? discoveryComment,
    String? archiveReports,
    String? siteComment,
    String? recordInfo,
  }) {
    return DepositEntity(
      id: id ?? this.id,
      depositName: depositName ?? this.depositName,
      feasibility: feasibility ?? this.feasibility,
      economicStatus: economicStatus ?? this.economicStatus,
      geoKnowledge: geoKnowledge ?? this.geoKnowledge,
      commodityGroup: commodityGroup ?? this.commodityGroup,
      commodity: commodity ?? this.commodity,
      miningStatus: miningStatus ?? this.miningStatus,
      unfcClassification: unfcClassification ?? this.unfcClassification,
      xUtm36s: xUtm36s ?? this.xUtm36s,
      yUtm36s: yUtm36s ?? this.yUtm36s,
      xWgs84: xWgs84 ?? this.xWgs84,
      yWgs84: yWgs84 ?? this.yWgs84,
      region: region ?? this.region,
      district: district ?? this.district,
      division: division ?? this.division,
      topoSheet250k: topoSheet250k ?? this.topoSheet250k,
      topoSheet100k: topoSheet100k ?? this.topoSheet100k,
      topoSheet50k: topoSheet50k ?? this.topoSheet50k,
      geologicalMap: geologicalMap ?? this.geologicalMap,
      access: access ?? this.access,
      geologicalDescription: geologicalDescription ?? this.geologicalDescription,
      geologicalTectonic: geologicalTectonic ?? this.geologicalTectonic,
      chronostratigraphicAge: chronostratigraphicAge ?? this.chronostratigraphicAge,
      hostRockLithology: hostRockLithology ?? this.hostRockLithology,
      regionalComment: regionalComment ?? this.regionalComment,
      generalDescription: generalDescription ?? this.generalDescription,
      shape: shape ?? this.shape,
      length: length ?? this.length,
      width: width ?? this.width,
      depth: depth ?? this.depth,
      dip: dip ?? this.dip,
      azimuth: azimuth ?? this.azimuth,
      strike: strike ?? this.strike,
      depositComment: depositComment ?? this.depositComment,
      mineralisationType: mineralisationType ?? this.mineralisationType,
      weatheringStatus: weatheringStatus ?? this.weatheringStatus,
      rocks: rocks ?? this.rocks,
      mineralDetails: mineralDetails ?? this.mineralDetails,
      resourceDetails: resourceDetails ?? this.resourceDetails,
      workDoneDetails: workDoneDetails ?? this.workDoneDetails,
      discoveryMethod: discoveryMethod ?? this.discoveryMethod,
      discoveryYear: discoveryYear ?? this.discoveryYear,
      workStartYear: workStartYear ?? this.workStartYear,
      stopYear: stopYear ?? this.stopYear,
      discoveryComment: discoveryComment ?? this.discoveryComment,
      archiveReports: archiveReports ?? this.archiveReports,
      siteComment: siteComment ?? this.siteComment,
      recordInfo: recordInfo ?? this.recordInfo,
    );
  }
}
