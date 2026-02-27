import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_scaffold.dart';
import '../../domain/entities/deposit_entity.dart';
import '../controllers/deposit_controller.dart';

class DepositFormPage extends StatefulWidget {
  final String? depositId;

  const DepositFormPage({super.key, this.depositId});

  @override
  State<DepositFormPage> createState() => _DepositFormPageState();
}

class _DepositFormPageState extends State<DepositFormPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isInit = true;

  // Header Data
  late TextEditingController _nameController;
  late TextEditingController _commodityController;
  late TextEditingController _commodityGroupController;
  late TextEditingController _miningStatusController;
  late TextEditingController _unfcClassificationController;
  String _economicStatus = 'Unknown';
  String _feasibility = 'Under Study';
  String _geoKnowledge = 'Preliminary';

  // Coordinates
  late TextEditingController _xUtm36sController;
  late TextEditingController _yUtm36sController;
  late TextEditingController _xWgs84Controller;
  late TextEditingController _yWgs84Controller;

  // Location
  late TextEditingController _regionController;
  late TextEditingController _districtController;
  late TextEditingController _divisionController;
  late TextEditingController _topoSheet250kController;
  late TextEditingController _topoSheet100kController;
  late TextEditingController _topoSheet50kController;
  late TextEditingController _geologicalMapController;
  late TextEditingController _accessController;

  // Regional Geology
  late TextEditingController _geologicalDescriptionController;
  late TextEditingController _geologicalTectonicController;
  late TextEditingController _chronostratigraphicAgeController;
  late TextEditingController _hostRockLithologyController;
  late TextEditingController _regionalCommentController;

  // Deposit Geology
  late TextEditingController _generalDescriptionController;
  late TextEditingController _shapeController;
  late TextEditingController _lengthController;
  late TextEditingController _widthController;
  late TextEditingController _depthController;
  late TextEditingController _dipController;
  late TextEditingController _azimuthController;
  late TextEditingController _strikeController;
  late TextEditingController _depositCommentController;

  // Mineralisation
  late TextEditingController _mineralisationTypeController;
  late TextEditingController _weatheringStatusController;

  // Discovery & Misc
  late TextEditingController _discoveryMethodController;
  late TextEditingController _discoveryYearController;
  late TextEditingController _workStartYearController;
  late TextEditingController _stopYearController;
  late TextEditingController _discoveryCommentController;
  late TextEditingController _archiveReportsController;
  late TextEditingController _siteCommentController;
  late TextEditingController _recordInfoController;

  // Rich Lists
  List<AssociatedRock> _rocks = [];
  List<MineralDetail> _mineralDetails = [];
  List<ResourceDetail> _resourceDetails = [];
  List<WorkDoneDetail> _workDoneDetails = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _initControllers();
      if (widget.depositId != null) {
        _loadDepositData();
      }
      _isInit = false;
    }
  }

  void _initControllers() {
    _nameController = TextEditingController();
    _commodityController = TextEditingController();
    _commodityGroupController = TextEditingController();
    _miningStatusController = TextEditingController();
    _unfcClassificationController = TextEditingController();
    _xUtm36sController = TextEditingController();
    _yUtm36sController = TextEditingController();
    _xWgs84Controller = TextEditingController();
    _yWgs84Controller = TextEditingController();
    _regionController = TextEditingController();
    _districtController = TextEditingController();
    _divisionController = TextEditingController();
    _topoSheet250kController = TextEditingController();
    _topoSheet100kController = TextEditingController();
    _topoSheet50kController = TextEditingController();
    _geologicalMapController = TextEditingController();
    _accessController = TextEditingController();
    _geologicalDescriptionController = TextEditingController();
    _geologicalTectonicController = TextEditingController();
    _chronostratigraphicAgeController = TextEditingController();
    _hostRockLithologyController = TextEditingController();
    _regionalCommentController = TextEditingController();
    _generalDescriptionController = TextEditingController();
    _shapeController = TextEditingController();
    _lengthController = TextEditingController();
    _widthController = TextEditingController();
    _depthController = TextEditingController();
    _dipController = TextEditingController();
    _azimuthController = TextEditingController();
    _strikeController = TextEditingController();
    _depositCommentController = TextEditingController();
    _mineralisationTypeController = TextEditingController();
    _weatheringStatusController = TextEditingController();
    _discoveryMethodController = TextEditingController();
    _discoveryYearController = TextEditingController();
    _workStartYearController = TextEditingController();
    _stopYearController = TextEditingController();
    _discoveryCommentController = TextEditingController();
    _archiveReportsController = TextEditingController();
    _siteCommentController = TextEditingController();
    _recordInfoController = TextEditingController();
  }

  void _loadDepositData() {
    final ctrl = context.read<DepositController>();
    final deposit = ctrl.deposits.firstWhere((d) => d.id == widget.depositId);

    _nameController.text = deposit.depositName;
    _commodityController.text = deposit.commodity ?? '';
    _commodityGroupController.text = deposit.commodityGroup ?? '';
    _miningStatusController.text = deposit.miningStatus ?? '';
    _unfcClassificationController.text = deposit.unfcClassification ?? '';
    _economicStatus = deposit.economicStatus;
    _feasibility = deposit.feasibility;
    _geoKnowledge = deposit.geoKnowledge;
    _xUtm36sController.text = deposit.xUtm36s ?? '';
    _yUtm36sController.text = deposit.yUtm36s ?? '';
    _xWgs84Controller.text = deposit.xWgs84 ?? '';
    _yWgs84Controller.text = deposit.yWgs84 ?? '';
    _regionController.text = deposit.region ?? '';
    _districtController.text = deposit.district ?? '';
    _divisionController.text = deposit.division ?? '';
    _topoSheet250kController.text = deposit.topoSheet250k ?? '';
    _topoSheet100kController.text = deposit.topoSheet100k ?? '';
    _topoSheet50kController.text = deposit.topoSheet50k ?? '';
    _geologicalMapController.text = deposit.geologicalMap ?? '';
    _accessController.text = deposit.access ?? '';
    _geologicalDescriptionController.text = deposit.geologicalDescription ?? '';
    _geologicalTectonicController.text = deposit.geologicalTectonic ?? '';
    _chronostratigraphicAgeController.text = deposit.chronostratigraphicAge ?? '';
    _hostRockLithologyController.text = deposit.hostRockLithology ?? '';
    _regionalCommentController.text = deposit.regionalComment ?? '';
    _generalDescriptionController.text = deposit.generalDescription ?? '';
    _shapeController.text = deposit.shape ?? '';
    _lengthController.text = deposit.length ?? '';
    _widthController.text = deposit.width ?? '';
    _depthController.text = deposit.depth ?? '';
    _dipController.text = deposit.dip ?? '';
    _azimuthController.text = deposit.azimuth ?? '';
    _strikeController.text = deposit.strike ?? '';
    _depositCommentController.text = deposit.depositComment ?? '';
    _mineralisationTypeController.text = deposit.mineralisationType ?? '';
    _weatheringStatusController.text = deposit.weatheringStatus ?? '';
    _discoveryMethodController.text = deposit.discoveryMethod ?? '';
    _discoveryYearController.text = deposit.discoveryYear ?? '';
    _workStartYearController.text = deposit.workStartYear ?? '';
    _stopYearController.text = deposit.stopYear ?? '';
    _discoveryCommentController.text = deposit.discoveryComment ?? '';
    _archiveReportsController.text = deposit.archiveReports ?? '';
    _siteCommentController.text = deposit.siteComment ?? '';
    _recordInfoController.text = deposit.recordInfo ?? '';

    _rocks = List.from(deposit.rocks);
    _mineralDetails = List.from(deposit.mineralDetails);
    _resourceDetails = List.from(deposit.resourceDetails);
    _workDoneDetails = List.from(deposit.workDoneDetails);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _commodityController.dispose();
    _commodityGroupController.dispose();
    _miningStatusController.dispose();
    _unfcClassificationController.dispose();
    _xUtm36sController.dispose();
    _yUtm36sController.dispose();
    _xWgs84Controller.dispose();
    _yWgs84Controller.dispose();
    _regionController.dispose();
    _districtController.dispose();
    _divisionController.dispose();
    _topoSheet250kController.dispose();
    _topoSheet100kController.dispose();
    _topoSheet50kController.dispose();
    _geologicalMapController.dispose();
    _accessController.dispose();
    _geologicalDescriptionController.dispose();
    _geologicalTectonicController.dispose();
    _chronostratigraphicAgeController.dispose();
    _hostRockLithologyController.dispose();
    _regionalCommentController.dispose();
    _generalDescriptionController.dispose();
    _shapeController.dispose();
    _lengthController.dispose();
    _widthController.dispose();
    _depthController.dispose();
    _dipController.dispose();
    _azimuthController.dispose();
    _strikeController.dispose();
    _depositCommentController.dispose();
    _mineralisationTypeController.dispose();
    _weatheringStatusController.dispose();
    _discoveryMethodController.dispose();
    _discoveryYearController.dispose();
    _workStartYearController.dispose();
    _stopYearController.dispose();
    _discoveryCommentController.dispose();
    _archiveReportsController.dispose();
    _siteCommentController.dispose();
    _recordInfoController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fix errors in Header Data')),
      );
      return;
    }

    final ctrl = context.read<DepositController>();
    final deposit = DepositEntity(
      id: widget.depositId ?? '',
      depositName: _nameController.text,
      feasibility: _feasibility,
      economicStatus: _economicStatus,
      geoKnowledge: _geoKnowledge,
      commodityGroup: _commodityGroupController.text,
      commodity: _commodityController.text,
      miningStatus: _miningStatusController.text,
      unfcClassification: _unfcClassificationController.text,
      xUtm36s: _xUtm36sController.text,
      yUtm36s: _yUtm36sController.text,
      xWgs84: _xWgs84Controller.text,
      yWgs84: _yWgs84Controller.text,
      region: _regionController.text,
      district: _districtController.text,
      division: _divisionController.text,
      topoSheet250k: _topoSheet250kController.text,
      topoSheet100k: _topoSheet100kController.text,
      topoSheet50k: _topoSheet50kController.text,
      geologicalMap: _geologicalMapController.text,
      access: _accessController.text,
      geologicalDescription: _geologicalDescriptionController.text,
      geologicalTectonic: _geologicalTectonicController.text,
      chronostratigraphicAge: _chronostratigraphicAgeController.text,
      hostRockLithology: _hostRockLithologyController.text,
      regionalComment: _regionalCommentController.text,
      generalDescription: _generalDescriptionController.text,
      shape: _shapeController.text,
      length: _lengthController.text,
      width: _widthController.text,
      depth: _depthController.text,
      dip: _dipController.text,
      azimuth: _azimuthController.text,
      strike: _strikeController.text,
      depositComment: _depositCommentController.text,
      mineralisationType: _mineralisationTypeController.text,
      weatheringStatus: _weatheringStatusController.text,
      rocks: _rocks,
      mineralDetails: _mineralDetails,
      resourceDetails: _resourceDetails,
      workDoneDetails: _workDoneDetails,
      archiveReports: _archiveReportsController.text,
      siteComment: _siteCommentController.text,
      recordInfo: _recordInfoController.text,
    );

    DepositEntity? result;
    if (widget.depositId != null) {
      result = await ctrl.updateDeposit(widget.depositId!, deposit);
    } else {
      result = await ctrl.createDeposit(deposit);
    }

    if (!mounted) return;
    if (result != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(widget.depositId != null ? 'Deposit updated' : 'Deposit created')),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultTabController(
      length: 10,
      child: AppScaffold(
        title: widget.depositId != null ? 'Edit Deposit (Premium)' : 'New Deposit (Premium)',
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              TabBar(
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                tabs: const [
                  Tab(text: 'Header Data'),
                  Tab(text: 'Location'),
                  Tab(text: 'Regional Geology'),
                  Tab(text: 'Deposit Geology'),
                  Tab(text: 'Mineralisation'),
                  Tab(text: 'Associated Rocks'),
                  Tab(text: 'Minerals'),
                  Tab(text: 'Resources'),
                  Tab(text: 'Work Done'),
                  Tab(text: 'Misc'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _buildHeaderTab(theme),
                    _buildLocationTab(theme),
                    _buildRegionalGeologyTab(theme),
                    _buildDepositGeologyTab(theme),
                    _buildMineralisationTab(theme),
                    _buildRichListTab<AssociatedRock>('Rocks', _rocks, (item) => _rocks.add(item)),
                    _buildRichListTab<MineralDetail>('Minerals', _mineralDetails, (item) => _mineralDetails.add(item)),
                    _buildRichListTab<ResourceDetail>('Resources', _resourceDetails, (item) => _resourceDetails.add(item)),
                    _buildRichListTab<WorkDoneDetail>('Work Done', _workDoneDetails, (item) => _workDoneDetails.add(item)),
                    _buildMiscTab(theme),
                  ],
                ),
              ),
              _buildFooter(theme),
            ],
          ),
        ),
      ),
    );
  }

  // --- Tab Builders ---

  Widget _buildHeaderTab(ThemeData theme) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        AppCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Basic Information', style: TextStyle(fontWeight: FontWeight.bold)),
              const Divider(),
              _buildTextField('Name *', _nameController, required: true),
              _buildTextField('Commodity Group', _commodityGroupController),
              _buildTextField('Commodity', _commodityController),
              _buildTextField('Mining Status', _miningStatusController),
              _buildTextField('UNFC Classification', _unfcClassificationController),
              const SizedBox(height: 16),
              _buildDropdownField('Economical Status', _economicStatus, ['Economic', 'Sub-Economic', 'Marginal', 'Unknown'], (val) => setState(() => _economicStatus = val!)),
              _buildDropdownField('Feasibility', _feasibility, ['Feasible', 'Pre-Feasible', 'Not Feasible', 'Under Study'], (val) => setState(() => _feasibility = val!)),
              _buildDropdownField('Geol. Knowledge', _geoKnowledge, ['High', 'Medium', 'Low', 'Preliminary'], (val) => setState(() => _geoKnowledge = val!)),
              const SizedBox(height: 16),
              const Text('Coordinates', style: TextStyle(fontWeight: FontWeight.bold)),
              const Divider(),
              Row(
                children: [
                  Expanded(child: _buildTextField('X UTM36S', _xUtm36sController)),
                  const SizedBox(width: 8),
                  Expanded(child: _buildTextField('Y UTM36S', _yUtm36sController)),
                ],
              ),
              Row(
                children: [
                  Expanded(child: _buildTextField('X WGS84', _xWgs84Controller)),
                  const SizedBox(width: 8),
                  Expanded(child: _buildTextField('Y WGS84', _yWgs84Controller)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLocationTab(ThemeData theme) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        AppCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Administrative Units', style: TextStyle(fontWeight: FontWeight.bold)),
              const Divider(),
              _buildTextField('Region', _regionController),
              _buildTextField('District', _districtController),
              _buildTextField('Division', _divisionController),
              const SizedBox(height: 16),
              const Text('Map Sheets', style: TextStyle(fontWeight: FontWeight.bold)),
              const Divider(),
              _buildTextField('Topo Sheet 1:250k', _topoSheet250kController),
              _buildTextField('Topo Sheet 1:100k', _topoSheet100kController),
              _buildTextField('Topo Sheet 1:50k', _topoSheet50kController),
              _buildTextField('Geological Map', _geologicalMapController),
              const SizedBox(height: 16),
              _buildTextField('Access', _accessController, maxLines: 3),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRegionalGeologyTab(ThemeData theme) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        AppCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField('Geological Description', _geologicalDescriptionController, maxLines: 4),
              const SizedBox(height: 16),
              const Text('Regional Settings', style: TextStyle(fontWeight: FontWeight.bold)),
              const Divider(),
              _buildTextField('Geological Tectonic', _geologicalTectonicController),
              _buildTextField('Chronostratigraphic Age', _chronostratigraphicAgeController),
              _buildTextField('Host Rock Lithology', _hostRockLithologyController),
              _buildTextField('Regional Comment', _regionalCommentController, maxLines: 3),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDepositGeologyTab(ThemeData theme) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        AppCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField('General Description', _generalDescriptionController, maxLines: 4),
              const SizedBox(height: 16),
              const Text('Structure', style: TextStyle(fontWeight: FontWeight.bold)),
              const Divider(),
              _buildTextField('Shape', _shapeController),
              Row(
                children: [
                  Expanded(child: _buildTextField('Length [m]', _lengthController)),
                  const SizedBox(width: 8),
                  Expanded(child: _buildTextField('Width [m]', _widthController)),
                ],
              ),
              Row(
                children: [
                  Expanded(child: _buildTextField('Depth [m]', _depthController)),
                  const SizedBox(width: 8),
                  Expanded(child: _buildTextField('Dip [°]', _dipController)),
                ],
              ),
              Row(
                children: [
                  Expanded(child: _buildTextField('Azimuth [°]', _azimuthController)),
                  const SizedBox(width: 8),
                  Expanded(child: _buildTextField('Strike [°]', _strikeController)),
                ],
              ),
              _buildTextField('Deposit Comment', _depositCommentController, maxLines: 3),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMineralisationTab(ThemeData theme) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        AppCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField('Mineralization Type', _mineralisationTypeController, maxLines: 3, hint: 'Comma separated'),
              _buildTextField('Status of Weathering', _weatheringStatusController, maxLines: 3, hint: 'Comma separated'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRichListTab<T>(String title, List<T> items, Function(T) onAdd) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            IconButton(
              onPressed: () => _showAddDialog<T>(title, onAdd),
              icon: const Icon(Icons.add_circle, color: Colors.blue),
            ),
          ],
        ),
        const Divider(),
        if (items.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 32.0),
            child: Center(child: Text('No items added yet', style: TextStyle(color: Colors.grey))),
          ),
        ...items.map((item) => _buildListItemCard(item)),
      ],
    );
  }

  Widget _buildListItemCard(dynamic item) {
    String title = '';
    String subtitle = '';
    if (item is AssociatedRock) {
      title = item.name;
      subtitle = '${item.stratigraphicAge ?? ''} - ${item.texture ?? ''}';
    } else if (item is MineralDetail) {
      title = item.mineral;
      subtitle = item.status ?? '';
    } else if (item is ResourceDetail) {
      title = item.commodity;
      subtitle = '${item.amountOre} ${item.amountUnit} @ ${item.grade}';
    } else if (item is WorkDoneDetail) {
      title = item.workDone;
      subtitle = '${item.startYear}-${item.stopYear} (${item.cost} ${item.costUnit})';
    }

    return AppCard(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.red),
          onPressed: () => setState(() {
            if (item is AssociatedRock) _rocks.remove(item);
            if (item is MineralDetail) _mineralDetails.remove(item);
            if (item is ResourceDetail) _resourceDetails.remove(item);
            if (item is WorkDoneDetail) _workDoneDetails.remove(item);
          }),
        ),
      ),
    );
  }

  Widget _buildMiscTab(ThemeData theme) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        AppCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Discovery', style: TextStyle(fontWeight: FontWeight.bold)),
              const Divider(),
              _buildTextField('Method', _discoveryMethodController),
              Row(
                children: [
                  Expanded(child: _buildTextField('Discovery Year', _discoveryYearController)),
                  const SizedBox(width: 8),
                  Expanded(child: _buildTextField('Work Start', _workStartYearController)),
                ],
              ),
              _buildTextField('Stop Year', _stopYearController),
              _buildTextField('Discovery Comment', _discoveryCommentController, maxLines: 3),
              const SizedBox(height: 16),
              const Text('Extended Information', style: TextStyle(fontWeight: FontWeight.bold)),
              const Divider(),
              _buildTextField('Archive Reports', _archiveReportsController, maxLines: 2),
              _buildTextField('Site Comment', _siteCommentController, maxLines: 3),
              _buildTextField('Record Info', _recordInfoController),
            ],
          ),
        ),
      ],
    );
  }

  // --- Helper Widgets ---

  Widget _buildTextField(String label, TextEditingController controller, {bool required = false, int maxLines = 1, String? hint}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: const OutlineInputBorder(),
        ),
        validator: required ? (value) => (value == null || value.isEmpty) ? '$label is required' : null : null,
      ),
    );
  }

  Widget _buildDropdownField(String label, String value, List<String> items, void Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
        items: items.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildFooter(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, -2))],
      ),
      child: Row(
        children: [
          Expanded(child: AppButton(onPressed: () => context.pop(), variant: AppButtonVariant.outline, child: const Text('Cancel'))),
          const SizedBox(width: 16),
          Expanded(
            child: Consumer<DepositController>(
              builder: (context, ctrl, _) {
                return AppButton(
                  onPressed: ctrl.isLoading ? null : _save,
                  variant: AppButtonVariant.primary,
                  child: ctrl.isLoading ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2)) : Text(widget.depositId != null ? 'Update' : 'Create'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showAddDialog<T>(String title, Function(T) onAdd) {
    // Simplified add dialog for the rich lists to keep things manageable
    final controller1 = TextEditingController();
    final controller2 = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add $title'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: controller1, decoration: InputDecoration(labelText: 'Name/Type')),
            TextField(controller: controller2, decoration: InputDecoration(labelText: 'Description/Status')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => context.pop(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              setState(() {
                if (T == AssociatedRock) {
                  onAdd(AssociatedRock(name: controller1.text, comment: controller2.text) as T);
                } else if (T == MineralDetail) {
                  onAdd(MineralDetail(mineral: controller1.text, status: controller2.text) as T);
                } else if (T == ResourceDetail) {
                  onAdd(ResourceDetail(commodity: controller1.text, amountOre: controller2.text) as T);
                } else if (T == WorkDoneDetail) {
                  onAdd(WorkDoneDetail(workDone: controller1.text, amount: controller2.text) as T);
                }
              });
              context.pop();
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
