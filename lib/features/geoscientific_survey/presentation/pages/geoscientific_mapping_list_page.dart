import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_scaffold.dart';
import '../../domain/entities/mapping_activity_entity.dart';
import '../controllers/mapping_activity_controller.dart';

class GeoscientificMappingListPage extends StatefulWidget {
  const GeoscientificMappingListPage({
    super.key,
    this.useScaffold = true,
  });

  /// When false, only the list content is built (for use inside GeosurveyShellPage).
  final bool useScaffold;

  @override
  State<GeoscientificMappingListPage> createState() =>
      _GeoscientificMappingListPageState();
}

class _GeoscientificMappingListPageState
    extends State<GeoscientificMappingListPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MappingActivityController>().loadActivities();
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

  List<MappingActivityEntity> _filter(
      List<MappingActivityEntity> activities, String query) {
    if (query.isEmpty) return activities;
    return activities.where((a) {
      return a.activityName.toLowerCase().contains(query) ||
          a.location.toLowerCase().contains(query) ||
          a.id.toLowerCase().contains(query) ||
          a.leadScientist.toLowerCase().contains(query) ||
          a.status.toLowerCase().contains(query);
    }).toList();
  }

  Future<void> _confirmDelete(
      BuildContext context, MappingActivityController ctrl, String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Mapping Activity'),
        content: const Text(
          'Are you sure you want to delete this mapping activity?',
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
    final ok = await ctrl.deleteActivity(id);
    if (!context.mounted) return;
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mapping activity deleted')),
      );
    } else if (ctrl.hasError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ctrl.errorMessage ?? 'Delete failed')),
      );
      ctrl.clearError();
    }
  }

  Widget _buildContent(BuildContext context, ThemeData theme) {
    return Consumer<MappingActivityController>(
        builder: (context, ctrl, _) {
          final filtered = _filter(ctrl.activities, _searchQuery);

          return Padding(
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
                  'Geoscientific Survey  >  Mapping activity',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Mapping Activity',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Manage field mapping and data collection activities for\nmineral exploration',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Spacer(),
                    AppButton(
                      onPressed: ctrl.isLoading
                          ? null
                          : () => context.push('/geoscientific-survey/mapping/new'),
                      variant: AppButtonVariant.primary,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.add, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            'New Mapping Activity',
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
                      hintText: 'Search mapping activities...',
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ctrl.isLoading && ctrl.activities.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : filtered.isEmpty
                          ? Center(
                              child: Text(
                                _searchQuery.isEmpty
                                    ? 'No mapping activities'
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
                                final a = filtered[index];
                                return _MappingActivityCard(
                                  activity: a,
                                  onView: () => context.push(
                                    '/geoscientific-survey/mapping-activity/${a.id}',
                                  ),
                                  onEdit: () => context.push(
                                    '/geoscientific-survey/mapping/${a.id}/edit',
                                  ),
                                  onDelete: () =>
                                      _confirmDelete(context, ctrl, a.id),
                                  isLoading: ctrl.isLoading,
                                );
                              },
                            ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Showing ${filtered.length} of ${ctrl.activities.length}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
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
        title: 'Mapping Activity',
        body: content,
      );
    }
    return content;
  }
}

class _MappingActivityCard extends StatelessWidget {
  const _MappingActivityCard({
    required this.activity,
    required this.onView,
    required this.onEdit,
    required this.onDelete,
    required this.isLoading,
  });

  final MappingActivityEntity activity;
  final VoidCallback onView;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final smallStyle = theme.textTheme.bodySmall;
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
                  activity.activityName,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              _TypeChip(label: activity.activityType),
            ],
          ),
          const SizedBox(height: 4),
          Text(activity.id, style: smallStyle?.copyWith(color: muted)),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              _LabelValue(label: 'Survey', value: activity.surveyType),
              _LabelValue(label: 'Location', value: activity.location),
              _LabelValue(label: 'Status', value: activity.status),
              _LabelValue(label: 'Lead', value: activity.leadScientist),
              _LabelValue(label: 'Created', value: activity.createdDate),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: isLoading ? null : onView,
                icon: const Icon(Icons.visibility_outlined, size: 18),
                label: const Text('View'),
              ),
              TextButton.icon(
                onPressed: isLoading ? null : onEdit,
                icon: const Icon(Icons.edit_outlined, size: 18),
                label: const Text('Edit'),
              ),
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

class _TypeChip extends StatelessWidget {
  const _TypeChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isInternal = label.toLowerCase() == 'internal';
    final bg = isInternal
        ? theme.colorScheme.primary.withValues(alpha: 0.1)
        : theme.colorScheme.secondary.withValues(alpha: 0.7);
    final fg = isInternal
        ? theme.colorScheme.primary
        : theme.colorScheme.onSecondary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: fg,
          fontWeight: FontWeight.w600,
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
