import '../../domain/entities/deposit_entity.dart';
import '../../domain/repositories/deposit_repository.dart';

class DepositRepositoryImpl implements DepositRepository {
  final List<DepositEntity> _mockDeposits = [
    DepositEntity(
      id: "1",
      depositName: "Geita Gold Deposit",
      feasibility: "Feasible",
      economicStatus: "Economic",
      geoKnowledge: "High",
      commodityGroup: "Metallic Minerals: Precious Metals",
      commodity: "Gold - Au",
      miningStatus: "Active Exploration",
      unfcClassification: "111",
      xUtm36s: "670504.54",
      yUtm36s: "9836235.42",
      xWgs84: "34.532579",
      yWgs84: "-1.489524",
      region: "MARA",
      district: "SERENGETI",
      division: "Kenambo",
      topoSheet250k: "4-4 - Narok",
      topoSheet100k: "6",
      topoSheet50k: "6/3",
      geologicalMap: "Quarter Degree Sheet 33",
      access: "86-90 km east of Musoma and 45km from Tarime via Nyamwaga",
      geologicalDescription:
          "The deposit is located within the Lake Victoria Goldfields, part of the Archaean Tanzania Craton. The regional geology is characterized by greenstone belts and granitoid intrusions.",
      geologicalTectonic: "Archaean Craton",
      chronostratigraphicAge: "Archaean",
      hostRockLithology: "Greenstone sequences, Metavolcanics, BIF",
      regionalComment:
          "Multiple deformation events have resulted in folding and faulting that control mineralization patterns.",
      generalDescription:
          "Orogenic gold deposit hosted in shear zones within metamorphosed volcanic and sedimentary rocks.",
      shape: "Tabular",
      length: "850",
      width: "120",
      depth: "350",
      dip: "65",
      azimuth: "045",
      strike: "135",
      depositComment:
          "Primarily greenstone sequences including metavolcanics, metasediments, and banded iron formations.",
      mineralisationType: "Vein-hosted, Disseminated, Replacement",
      weatheringStatus: "Fresh, Partially weathered, Oxidized near surface",
      rocks: [
        const AssociatedRock(
          name: "Metavolcanics",
          stratigraphicAge: "Archaean",
          alteration: "Chlorite, Sericite",
          color: "Green-grey",
          texture: "Fine-grained",
          position: "Host",
          comment: "Primary host rock",
        ),
        const AssociatedRock(
          name: "Banded Iron Formation",
          stratigraphicAge: "Archaean",
          alteration: "Silicification",
          color: "Red-brown",
          texture: "Banded",
          position: "Host",
          comment: "Mineralized zones",
        ),
        const AssociatedRock(
          name: "Quartz Veins",
          alteration: "Carbonate",
          color: "White-grey",
          texture: "Massive",
          position: "Vein",
          comment: "Gold-bearing",
        ),
      ],
      mineralDetails: [
        const MineralDetail(
          mineral: "Gold (Au)",
          status: "Primary Commodity",
          comment: "Main economic mineral",
        ),
        const MineralDetail(
          mineral: "Pyrite",
          status: "Sulfide",
          comment: "Associated sulfide mineral",
        ),
        const MineralDetail(
          mineral: "Chalcopyrite",
          status: "Sulfide",
          comment: "Minor copper-bearing mineral",
        ),
      ],
      resourceDetails: [
        const ResourceDetail(
          commodity: "Gold",
          amountOre: "2,500,000",
          amountUnit: "tonnes",
          grade: "2.5",
          gradeUnit: "g/t",
          content: "200,000",
          contentUnit: "oz",
          classification: "Inferred",
          date: "2024-03",
          archiveReport: "REP-2024-001",
          name: "Main Zone Estimate",
        ),
        const ResourceDetail(
          commodity: "Gold",
          amountOre: "850,000",
          amountUnit: "tonnes",
          grade: "3.2",
          gradeUnit: "g/t",
          content: "87,000",
          contentUnit: "oz",
          classification: "Indicated",
          date: "2024-03",
          archiveReport: "REP-2024-001",
          name: "High Grade Zone",
        ),
      ],
      workDoneDetails: [
        const WorkDoneDetail(
          workDone: "Diamond Drilling",
          startYear: "2023",
          stopYear: "2024",
          amount: "15,000",
          amountUnit: "meters",
          cost: "1,200,000",
          costUnit: "USD",
        ),
        const WorkDoneDetail(
          workDone: "Soil Sampling",
          startYear: "2022",
          stopYear: "2022",
          amount: "5,000",
          amountUnit: "samples",
          cost: "150,000",
          costUnit: "USD",
        ),
      ],
      archiveReports: "REP-2024-001, GEO-MARA-042",
      recordInfo: "Created by Admin on 2024-01-15",
    ),
    DepositEntity(
      id: "2",
      depositName: "Mererani Tanzanite",
      feasibility: "Feasible",
      economicStatus: "Economic",
      geoKnowledge: "High",
      commodityGroup: "Non-Metallic Minerals: Gemstones",
      commodity: "Tanzanite",
      miningStatus: "Active Mining",
      unfcClassification: "111",
    ),
    DepositEntity(
      id: "3",
      depositName: "Kabanga Nickel Project",
      feasibility: "Pre-Feasible",
      economicStatus: "Economic",
      geoKnowledge: "Medium",
    ),
  ];

  @override
  Future<List<DepositEntity>> getDeposits() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockDeposits;
  }

  @override
  Future<DepositEntity?> getDepositById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _mockDeposits.firstWhere((d) => d.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<DepositEntity?> createDeposit(DepositEntity deposit) async {
    await Future.delayed(const Duration(milliseconds: 800));
    final newDeposit = deposit.copyWith(id: DateTime.now().millisecondsSinceEpoch.toString());
    _mockDeposits.add(newDeposit);
    return newDeposit;
  }

  @override
  Future<DepositEntity?> updateDeposit(String id, DepositEntity deposit) async {
    await Future.delayed(const Duration(milliseconds: 800));
    final index = _mockDeposits.indexWhere((d) => d.id == id);
    if (index != -1) {
      _mockDeposits[index] = deposit;
      return deposit;
    }
    return null;
  }

  @override
  Future<bool> deleteDeposit(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _mockDeposits.removeWhere((d) => d.id == id);
    return true;
  }
}
