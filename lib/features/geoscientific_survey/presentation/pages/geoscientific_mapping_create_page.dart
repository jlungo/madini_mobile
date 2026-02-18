import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../shared/widgets/app_scaffold.dart';
import '../../domain/entities/mapping_activity_entity.dart';
import '../controllers/mapping_activity_controller.dart';
import '../widgets/mapping_activity_form.dart';

class GeoscientificMappingCreatePage extends StatelessWidget {
  const GeoscientificMappingCreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppScaffold(
      body: Consumer<MappingActivityController>(
        builder: (context, ctrl, _) {
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
                                  'Create New Mapping Activity',
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
                            'Fill in the details to create a new mapping activity.',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.7),
                            ),
                          ),
                          const SizedBox(height: 20),
                          MappingActivityForm(
                            onSave: (MappingActivityEntity entity) =>
                                _handleSave(context, ctrl, entity),
                            isLoading: ctrl.isLoading,
                            submitLabel: 'Create Activity',
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
    final created = await ctrl.createActivity(entity);
    if (!context.mounted) return;
    if (created != null) {
      context.pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Mapping activity created successfully')),
      );
    } else if (ctrl.hasError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(ctrl.errorMessage ?? 'Failed to create'),
          action: SnackBarAction(
            label: 'Dismiss',
            onPressed: () => ctrl.clearError(),
          ),
        ),
      );
    }
  }
}
