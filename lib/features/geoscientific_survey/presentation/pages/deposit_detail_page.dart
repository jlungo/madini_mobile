import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/widgets/app_scaffold.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/status_badge.dart';
import '../../domain/entities/deposit_entity.dart';
import '../controllers/deposit_controller.dart';

class DepositDetailPage extends StatefulWidget {
  final String depositId;

  const DepositDetailPage({super.key, required this.depositId});

  @override
  State<DepositDetailPage> createState() => _DepositDetailPageState();
}

class _DepositDetailPageState extends State<DepositDetailPage> {
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      context.read<DepositController>().fetchDepositById(widget.depositId);
      _isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppScaffold(
      title: 'Deposit Details',
      body: Consumer<DepositController>(
        builder: (context, ctrl, _) {
          if (ctrl.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final deposit = ctrl.selectedDeposit;
          if (deposit == null) {
            return const Center(child: Text('Deposit not found'));
          }

          return DefaultTabController(
            length: 12,
            child: Column(
              children: [
                _buildHeader(deposit, theme),
                TabBar(
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  tabs: const [
                    Tab(text: 'Location'),
                    Tab(text: 'Regional Geology'),
                    Tab(text: 'Deposit Geology'),
                    Tab(text: 'Associated Rocks'),
                    Tab(text: 'Mineralisation'),
                    Tab(text: 'Minerals'),
                    Tab(text: 'Reserves/Resources'),
                    Tab(text: 'Work Done'),
                    Tab(text: 'Discovery'),
                    Tab(text: 'Archive Reports'),
                    Tab(text: 'Comment'),
                    Tab(text: 'Record Info'),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      _buildLocationTab(deposit),
                      _buildRegionalGeologyTab(deposit),
                      _buildDepositGeologyTab(deposit),
                      _buildAssociatedRocksTab(deposit),
                      _buildMineralisationTab(deposit),
                      _buildMineralsTab(deposit),
                      _buildResourcesTab(deposit),
                      _buildWorkDoneTab(deposit),
                      _buildDiscoveryTab(deposit),
                      _buildArchiveTab(deposit),
                      _buildCommentTab(deposit),
                      _buildRecordInfoTab(deposit),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(DepositEntity deposit, ThemeData theme) {
    return AppCard(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  deposit.depositName,
                  style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              StatusBadge(status: deposit.economicStatus),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            deposit.commodityGroup ?? 'Unknown Group',
            style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.secondary),
          ),
          const Divider(height: 24),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              _buildHeaderItem('Feasibility', deposit.feasibility),
              _buildHeaderItem('Geol. Knowledge', deposit.geoKnowledge),
              _buildHeaderItem('Status', deposit.miningStatus ?? 'N/A'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
        Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildLocationTab(DepositEntity deposit) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionCard('Administrative Units', [
          _buildDetailRow('Region', deposit.region),
          _buildDetailRow('District', deposit.district),
          _buildDetailRow('Division', deposit.division),
        ]),
        const SizedBox(height: 16),
        _buildSectionCard('Map Sheets References', [
          _buildDetailRow('Topo Sheet 1:250k', deposit.topoSheet250k),
          _buildDetailRow('Topo Sheet 1:100k', deposit.topoSheet100k),
          _buildDetailRow('Topo Sheet 1:50k', deposit.topoSheet50k),
          _buildDetailRow('Geological Map', deposit.geologicalMap),
        ]),
        const SizedBox(height: 16),
        _buildSectionCard('Access', [
          Text(deposit.access ?? 'No access information provided', style: const TextStyle(fontSize: 14)),
        ]),
      ],
    );
  }

  Widget _buildRegionalGeologyTab(DepositEntity deposit) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionCard('Geological Description', [
          Text(deposit.geologicalDescription ?? 'No description available', style: const TextStyle(fontSize: 14)),
        ]),
        const SizedBox(height: 16),
        _buildSectionCard('Regional Settings', [
          _buildDetailRow('Tectonic', deposit.geologicalTectonic),
          _buildDetailRow('Age', deposit.chronostratigraphicAge),
          _buildDetailRow('Host Rock Lithology', deposit.hostRockLithology),
        ]),
        const SizedBox(height: 16),
        _buildSectionCard('Comment', [
          Text(deposit.regionalComment ?? 'No comment', style: const TextStyle(fontSize: 14)),
        ]),
      ],
    );
  }

  Widget _buildDepositGeologyTab(DepositEntity deposit) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionCard('General Description', [
          Text(deposit.generalDescription ?? 'No description available', style: const TextStyle(fontSize: 14)),
        ]),
        const SizedBox(height: 16),
        _buildSectionCard('Structure', [
          _buildDetailRow('Shape', deposit.shape),
          Row(
            children: [
              Expanded(child: _buildDetailRow('Length [m]', deposit.length)),
              Expanded(child: _buildDetailRow('Width [m]', deposit.width)),
            ],
          ),
          Row(
            children: [
              Expanded(child: _buildDetailRow('Depth [m]', deposit.depth)),
              Expanded(child: _buildDetailRow('Dip [°]', deposit.dip)),
            ],
          ),
          Row(
            children: [
              Expanded(child: _buildDetailRow('Azimuth [°]', deposit.azimuth)),
              Expanded(child: _buildDetailRow('Strike [°]', deposit.strike)),
            ],
          ),
        ]),
        const SizedBox(height: 16),
        _buildSectionCard('Comment', [
          Text(deposit.depositComment ?? 'No comment', style: const TextStyle(fontSize: 14)),
        ]),
      ],
    );
  }

  Widget _buildAssociatedRocksTab(DepositEntity deposit) {
    if (deposit.rocks.isEmpty) return _buildEmptyTab('No associated rocks recorded');
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Name')),
            DataColumn(label: Text('Age')),
            DataColumn(label: Text('Alteration')),
            DataColumn(label: Text('Color')),
            DataColumn(label: Text('Texture')),
            DataColumn(label: Text('Position')),
          ],
          rows: deposit.rocks.map((rock) => DataRow(cells: [
            DataCell(Text(rock.name)),
            DataCell(Text(rock.stratigraphicAge ?? '-')),
            DataCell(Text(rock.alteration ?? '-')),
            DataCell(Text(rock.color ?? '-')),
            DataCell(Text(rock.texture ?? '-')),
            DataCell(Text(rock.position ?? '-')),
          ])).toList(),
        ),
      ),
    );
  }

  Widget _buildMineralisationTab(DepositEntity deposit) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionCard('Mineralization Type', [
          if (deposit.mineralisationType != null)
            ...deposit.mineralisationType!.split(',').map((e) => _buildChipItem(e.trim())),
          if (deposit.mineralisationType == null) const Text('No data'),
        ]),
        const SizedBox(height: 16),
        _buildSectionCard('Status of Weathering', [
          if (deposit.weatheringStatus != null)
            ...deposit.weatheringStatus!.split(',').map((e) => _buildChipItem(e.trim())),
          if (deposit.weatheringStatus == null) const Text('No data'),
        ]),
      ],
    );
  }

  Widget _buildMineralsTab(DepositEntity deposit) {
    if (deposit.mineralDetails.isEmpty) return _buildEmptyTab('No minerals recorded');
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Mineral')),
          DataColumn(label: Text('Status')),
          DataColumn(label: Text('Comment')),
        ],
        rows: deposit.mineralDetails.map((m) => DataRow(cells: [
          DataCell(Text(m.mineral)),
          DataCell(Badge(label: Text(m.status ?? 'N/A'))),
          DataCell(Text(m.comment ?? '-')),
        ])).toList(),
      ),
    );
  }

  Widget _buildResourcesTab(DepositEntity deposit) {
    if (deposit.resourceDetails.isEmpty) return _buildEmptyTab('No resource data recorded');
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Commodity')),
            DataColumn(label: Text('Amount')),
            DataColumn(label: Text('Grade')),
            DataColumn(label: Text('Content')),
            DataColumn(label: Text('Classification')),
          ],
          rows: deposit.resourceDetails.map((r) => DataRow(cells: [
            DataCell(Text(r.commodity)),
            DataCell(Text('${r.amountOre} ${r.amountUnit}')),
            DataCell(Text('${r.grade} ${r.gradeUnit}')),
            DataCell(Text('${r.content} ${r.contentUnit}')),
            DataCell(StatusBadge(status: r.classification ?? 'N/A')),
          ])).toList(),
        ),
      ),
    );
  }

  Widget _buildWorkDoneTab(DepositEntity deposit) {
    if (deposit.workDoneDetails.isEmpty) return _buildEmptyTab('No work done records');
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Activity')),
            DataColumn(label: Text('Period')),
            DataColumn(label: Text('Amount')),
            DataColumn(label: Text('Cost')),
          ],
          rows: deposit.workDoneDetails.map((w) => DataRow(cells: [
            DataCell(Text(w.workDone)),
            DataCell(Text('${w.startYear}-${w.stopYear}')),
            DataCell(Text('${w.amount} ${w.amountUnit}')),
            DataCell(Text('${w.cost} ${w.costUnit}')),
          ])).toList(),
        ),
      ),
    );
  }

  Widget _buildDiscoveryTab(DepositEntity deposit) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionCard('Discovery Information', [
          _buildDetailRow('Method', deposit.discoveryMethod),
          _buildDetailRow('Discovery Year', deposit.discoveryYear),
          _buildDetailRow('Work Start Year', deposit.workStartYear),
          _buildDetailRow('Stop Year', deposit.stopYear),
        ]),
        const SizedBox(height: 16),
        _buildSectionCard('Comment', [
          Text(deposit.discoveryComment ?? 'No comment', style: const TextStyle(fontSize: 14)),
        ]),
      ],
    );
  }

  Widget _buildArchiveTab(DepositEntity deposit) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionCard('Archive Reports', [
          Text(deposit.archiveReports ?? 'No archive reports listed', style: const TextStyle(fontSize: 14)),
        ]),
      ],
    );
  }

  Widget _buildCommentTab(DepositEntity deposit) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionCard('Site Comments', [
          Text(deposit.siteComment ?? 'No overall site comments', style: const TextStyle(fontSize: 14)),
        ]),
      ],
    );
  }

  Widget _buildRecordInfoTab(DepositEntity deposit) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionCard('Record Information', [
          Text(deposit.recordInfo ?? 'No record information available', style: const TextStyle(fontSize: 14)),
        ]),
      ],
    );
  }

  Widget _buildSectionCard(String title, List<Widget> children) {
    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const Divider(),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, color: Colors.grey)),
          Text(value ?? 'N/A', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildChipItem(String label) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline, size: 16, color: Colors.green),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildEmptyTab(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.info_outline, size: 48, color: Colors.grey),
            const SizedBox(height: 16),
            Text(message, style: const TextStyle(color: Colors.grey), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
