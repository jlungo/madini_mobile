import 'package:flutter/material.dart';

import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_scaffold.dart';

class DataShopPage extends StatelessWidget {
  const DataShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppScaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Data Shop',
              style: theme.textTheme.bodyMedium?.copyWith(
                color:
                    theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Dashboard',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const _MetricCard(
              title: 'Total Sales',
              value: 'TZS 1,234,567',
            ),
            const SizedBox(height: 12),
            const _MetricCard(
              title: 'Active Materials',
              value: '45',
            ),
            const SizedBox(height: 12),
            const _MetricCard(
              title: 'Total Orders',
              value: '89',
            ),
            const SizedBox(height: 12),
            const _MetricCard(
              title: 'New Customers',
              value: '12',
            ),
            const SizedBox(height: 24),
            Text(
              'Recent Orders',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            const _RecentOrdersCard(),
            const SizedBox(height: 24),
            Text(
              'Popular Materials',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            const _PopularMaterialsCard(),
          ],
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;

  const _MetricCard({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppCard(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _RecentOrdersCard extends StatelessWidget {
  const _RecentOrdersCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    TextStyle headerStyle = theme.textTheme.bodySmall!.copyWith(
      fontWeight: FontWeight.w600,
      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
    );

    TextStyle rowStyle = theme.textTheme.bodySmall!.copyWith(
      fontWeight: FontWeight.w500,
    );

    return AppCard(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text('Order ID', style: headerStyle),
              ),
              Expanded(
                child: Text('Customer', style: headerStyle),
              ),
              Expanded(
                child: Text('Amount', style: headerStyle),
              ),
              Expanded(
                child: Text('Status', style: headerStyle),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Divider(
            height: 1,
            color: theme.colorScheme.outlineVariant,
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text('#123', style: rowStyle),
              ),
              Expanded(
                child: Text('John Doe', style: rowStyle),
              ),
              Expanded(
                child: Text('TZS 45,000', style: rowStyle),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Completed',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PopularMaterialsCard extends StatelessWidget {
  const _PopularMaterialsCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    TextStyle headerStyle = theme.textTheme.bodySmall!.copyWith(
      fontWeight: FontWeight.w600,
      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
    );

    TextStyle rowStyle = theme.textTheme.bodySmall!.copyWith(
      fontWeight: FontWeight.w500,
    );

    return AppCard(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Text('Material', style: headerStyle),
              ),
              Expanded(
                child: Text('Downloads', style: headerStyle),
              ),
              Expanded(
                child: Text('Revenue', style: headerStyle),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Divider(
            height: 1,
            color: theme.colorScheme.outlineVariant,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  'Geological Map - Region A',
                  style: rowStyle,
                ),
              ),
              Expanded(
                child: Text('34', style: rowStyle),
              ),
              Expanded(
                child: Text('TZS 340,000', style: rowStyle),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

