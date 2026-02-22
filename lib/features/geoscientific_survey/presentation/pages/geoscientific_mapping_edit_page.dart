import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../shared/widgets/app_scaffold.dart';
import '../../domain/entities/mapping_activity_entity.dart';
import '../controllers/mapping_activity_controller.dart';
import '../widgets/mapping_activity_form.dart';

class GeoscientificMappingEditPage extends StatefulWidget {
  const GeoscientificMappingEditPage({super.key, required this.activityId});

  final String activityId;

  @override
  State<GeoscientificMappingEditPage> createState() =>
      _GeoscientificMappingEditPageState();
}

class _GeoscientificMappingEditPageState extends State<GeoscientificMappingEditPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MappingActivityController>().loadActivityById(widget.activityId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppScaffold(
      body: Consumer<MappingActivityController>(
        builder: (context, ctrl, _) {
          if (ctrl.isLoading && ctrl.selectedActivity == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final activity = ctrl.selectedActivity;
          if (activity == null || activity.id != widget.activityId) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Activity not found',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: () => context.pop(),
                      child: const Text('Back'),
                    ),
                  ],
                ),
              ),
            );
          }

          return Stack(
            children: [
              Container(color: Colors.black.withValues(alpha: 0.2)),
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Card(
                    margin: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  'Edit Mapping Activity',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: ctrl.isLoading
                                    ? null
                                    : () => context.pop(),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Update the mapping activity details below.',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.7),
                            ),
                          ),
                          const SizedBox(height: 20),
                          MappingActivityForm(
                            initial: activity,
                            onSave: (MappingActivityEntity entity) =>
                                _handleSave(context, ctrl, entity),
                            isLoading: ctrl.isLoading,
                            submitLabel: 'Update Activity',
                            cancelLabel: 'Cancel',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _handleSave(
    BuildContext context,
    MappingActivityController ctrl,
    MappingActivityEntity entity,
  ) async {
    final updated = await ctrl.updateActivity(widget.activityId, entity);
    if (!context.mounted) return;
    if (updated != null) {
      context.pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Mapping activity updated successfully')),
      );
    } else if (ctrl.hasError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(ctrl.errorMessage ?? 'Failed to update'),
          action: SnackBarAction(
            label: 'Dismiss',
            onPressed: () => ctrl.clearError(),
          ),
        ),
      );
    }
  }
}
