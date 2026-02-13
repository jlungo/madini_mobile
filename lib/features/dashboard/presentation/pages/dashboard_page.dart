import 'package:flutter/material.dart';

import '../../../../shared/widgets/app_scaffold.dart';
import '../widgets/stat_card.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppScaffold(
      usePortalHeader: false,
      title: 'Dashboard',
      body: Column(
        children: [
          Material(
            color: theme.colorScheme.surface,
            child: TabBar(
              controller: _tabController,
              labelColor: theme.colorScheme.primary,
              unselectedLabelColor:
                  theme.colorScheme.onSurface.withValues(alpha: 0.7),
              indicatorColor: theme.colorScheme.primary,
              tabs: const [
                Tab(text: 'Overview'),
                Tab(text: 'Analytics'),
                Tab(text: 'Reports'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOverview(context),
                _buildPlaceholder(context, 'Analytics'),
                _buildPlaceholder(context, 'Reports'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverview(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.count(
        crossAxisCount: 1,
        mainAxisSpacing: 12,
        childAspectRatio: 2.8,
        children: const [
          StatCard(
            title: 'Total Revenue',
            value: '\$45,231.89',
            subtitle: '+20.1% from last month',
            icon: Icons.show_chart,
          ),
          StatCard(
            title: 'Active Users',
            value: '2,431',
            subtitle: '+5.4% from last month',
            icon: Icons.people_outline,
          ),
          StatCard(
            title: 'Open Tickets',
            value: '87',
            subtitle: 'Pending resolution',
            icon: Icons.support_agent,
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder(BuildContext context, String label) {
    final theme = Theme.of(context);
    return Center(
      child: Text(
        '$label coming soon',
        style: theme.textTheme.bodyMedium,
      ),
    );
  }
}

