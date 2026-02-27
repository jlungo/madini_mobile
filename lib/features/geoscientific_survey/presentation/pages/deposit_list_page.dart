import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/security/permissions.dart';
import '../../../../features/auth/presentation/providers/auth_provider.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_scaffold.dart';
import '../../domain/entities/deposit_entity.dart';
import '../controllers/deposit_controller.dart';

class DepositListPage extends StatefulWidget {
  const DepositListPage({
    super.key,
    this.useScaffold = true,
  });

  final bool useScaffold;

  @override
  State<DepositListPage> createState() => _DepositListPageState();
}

class _DepositListPageState extends State<DepositListPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DepositController>().loadDeposits();
    });
    _searchController.addListener(() {
      setState(() => _searchQuery = _searchController.text.trim().toLowerCase());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<DepositEntity> _filter(List<DepositEntity> deposits, String query) {
    if (query.isEmpty) return deposits;
    return deposits.where((d) {
      return d.depositName.toLowerCase().contains(query) ||
          (d.commodity?.toLowerCase().contains(query) ?? false) ||
          d.feasibility.toLowerCase().contains(query) ||
          d.economicStatus.toLowerCase().contains(query) ||
          d.geoKnowledge.toLowerCase().contains(query);
    }).toList();
  }

  Future<void> _confirmDelete(
      BuildContext context, DepositController ctrl, String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Deposit'),
        content: const Text(
          'Are you sure you want to delete this deposit?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (!context.mounted || confirmed != true) return;
    final ok = await ctrl.deleteDeposit(id);
    if (!context.mounted) return;
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Deposit deleted')),
      );
    } else if (ctrl.hasError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ctrl.errorMessage ?? 'Delete failed')),
      );
      ctrl.clearError();
    }
  }

  Widget _buildContent(BuildContext context, ThemeData theme) {
    final user = context.watch<AuthProvider>().user;
    final canCreate = user != null &&
        user.hasAnyPermission([GeosurveyPermissions.depositCreate]);
    final canDelete = user != null &&
        user.hasAnyPermission([GeosurveyPermissions.depositDeleteAny]);

    return Consumer<DepositController>(
      builder: (context, ctrl, _) {
        final filtered = _filter(ctrl.deposits, _searchQuery);

        return SizedBox.expand(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (ctrl.hasError)
                  Material(
                    color: theme.colorScheme.errorContainer,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              ctrl.errorMessage ?? 'Error',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onErrorContainer,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: ctrl.clearError,
                            child: const Text('Dismiss'),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (ctrl.hasError) const SizedBox(height: 12),
                Text(
                  'Geoscientific Survey  >  Deposits',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Deposits & Mineral Occurrences',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Manage and view all mineral deposits and occurrences',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 16),
                if (canCreate)
                  Row(
                    children: [
                      const Spacer(),
                      AppButton(
                        onPressed: ctrl.isLoading
                            ? null
                            : () => context.push('/geoscientific-survey/deposits/new'),
                        variant: AppButtonVariant.primary,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.add, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              'Add New Deposit',
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: theme.colorScheme.onPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 16),
                AppCard(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Search deposits...',
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ctrl.isLoading && ctrl.deposits.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : filtered.isEmpty
                          ? Center(
                              child: Text(
                                _searchQuery.isEmpty
                                    ? 'No deposits found'
                                    : 'No results for "$_searchQuery"',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurface
                                      .withValues(alpha: 0.7),
                                ),
                              ),
                            )
                          : ListView.separated(
                              itemCount: filtered.length,
                              separatorBuilder: (_, _) =>
                                  const SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                final d = filtered[index];
                                return _DepositCard(
                                  deposit: d,
                                  canView: true,
                                  canEdit: true, // simplified for now
                                  canDelete: canDelete,
                                  onView: () => context.push(
                                    '/geoscientific-survey/deposits/${d.id}',
                                  ),
                                  onEdit: () => context.push(
                                    '/geoscientific-survey/deposits/${d.id}/edit',
                                  ),
                                  onDelete: () =>
                                      _confirmDelete(context, ctrl, d.id),
                                  isLoading: ctrl.isLoading,
                                );
                              },
                            ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Showing ${filtered.length} of ${ctrl.deposits.length}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final content = _buildContent(context, theme);
    if (widget.useScaffold) {
      return AppScaffold(
        title: 'Deposits',
        body: content,
      );
    }
    return content;
  }
}

class _DepositCard extends StatelessWidget {
  const _DepositCard({
    required this.deposit,
    required this.canView,
    required this.canEdit,
    required this.canDelete,
    required this.onView,
    required this.onEdit,
    required this.onDelete,
    required this.isLoading,
  });

  final DepositEntity deposit;
  final bool canView;
  final bool canEdit;
  final bool canDelete;
  final VoidCallback onView;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurface.withValues(alpha: 0.7);

    return AppCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  deposit.depositName,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              _StatusBadge(label: deposit.feasibility, type: 'feasibility'),
            ],
          ),
          const SizedBox(height: 6),
          if (deposit.commodity != null)
            Text(deposit.commodity!, style: theme.textTheme.bodySmall?.copyWith(color: muted)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              _LabelValue(label: 'Economic-status', value: deposit.economicStatus),
              _LabelValue(label: 'Knowledge', value: deposit.geoKnowledge),
              if (deposit.region != null) _LabelValue(label: 'Region', value: deposit.region!),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (canView)
                TextButton.icon(
                  onPressed: isLoading ? null : onView,
                  icon: const Icon(Icons.visibility_outlined, size: 18),
                  label: const Text('View'),
                ),
              if (canEdit)
                TextButton.icon(
                  onPressed: isLoading ? null : onEdit,
                  icon: const Icon(Icons.edit_outlined, size: 18),
                  label: const Text('Edit'),
                ),
              if (canDelete)
                TextButton.icon(
                  onPressed: isLoading ? null : onDelete,
                  icon: Icon(Icons.delete_outline, size: 18,
                      color: theme.colorScheme.error),
                  label: Text('Delete',
                      style: TextStyle(color: theme.colorScheme.error)),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.label, required this.type});
  final String label;
  final String type;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Color bg = theme.colorScheme.surfaceContainer;
    Color fg = theme.colorScheme.onSurface;

    if (label == 'Feasible' || label == 'Economic' || label == 'High') {
      bg = Colors.green.withValues(alpha: 0.1);
      fg = Colors.green;
    } else if (label == 'Pre-Feasible' || label == 'Marginal' || label == 'Medium') {
      bg = Colors.blue.withValues(alpha: 0.1);
      fg = Colors.blue;
    } else if (label == 'Not Feasible' || label == 'Sub-Economic' || label == 'Low') {
      bg = Colors.orange.withValues(alpha: 0.1);
      fg = Colors.orange;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: fg,
        ),
      ),
    );
  }
}

class _LabelValue extends StatelessWidget {
  const _LabelValue({required this.label, required this.value});
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurface.withValues(alpha: 0.7);
    return Text(
      '$label: $value',
      style: theme.textTheme.bodySmall?.copyWith(color: muted),
    );
  }
}
