import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_scaffold.dart';
import '../../domain/entities/mapping_activity_entity.dart';
import '../controllers/mapping_activity_controller.dart';
import '../widgets/step_content_activity_details.dart';
import '../widgets/step_content_basemap.dart';
import '../widgets/step_content_map_report.dart';
import '../widgets/step_content_sample_analysis.dart';
import '../widgets/step_content_preserve.dart';
import '../widgets/step_content_site_visit.dart';
import '../widgets/workflow_step_list.dart';

/// Detail page for a mapping activity: header (name, id, location, status, Edit)
/// and placeholder for workflow steps (TODO 8+).
class MappingActivityDetailPage extends StatefulWidget {
  const MappingActivityDetailPage({super.key, required this.activityId});

  final String activityId;

  @override
  State<MappingActivityDetailPage> createState() =>
      _MappingActivityDetailPageState();
}

class _MappingActivityDetailPageState extends State<MappingActivityDetailPage> {
  String? _selectedStepId;

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
      title: 'Mapping Activity',
      actions: [
        IconButton(
          icon: const Icon(Icons.edit_outlined),
          onPressed: () => context.push(
            '/geoscientific-survey/mapping/${widget.activityId}/edit',
          ),
        ),
      ],
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

          final steps = buildWorkflowSteps(activity);
          final selectedId = _selectedStepId ?? (steps.isNotEmpty ? steps.first.id : '');
          WorkflowStep? selectedStep;
          for (final s in steps) {
            if (s.id == selectedId) {
              selectedStep = s;
              break;
            }
          }
          selectedStep ??= steps.isNotEmpty ? steps.first : null;

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _DetailHeader(activity: activity),
                const SizedBox(height: 24),
                AppCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Flow',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      WorkflowStepList(
                        steps: steps,
                        selectedStepId: selectedId,
                        onStepSelected: (id) =>
                            setState(() => _selectedStepId = id),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                if (selectedStep != null)
                  _buildStepContent(context, activity, selectedStep, ctrl),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStepContent(
    BuildContext context,
    MappingActivityEntity activity,
    WorkflowStep selectedStep,
    MappingActivityController ctrl,
  ) {
    switch (selectedStep.id) {
      case 'create':
        return StepContentActivityDetails(activity: activity);
      case 'basemap':
        return StepContentBasemap(activity: activity);
      case 'site-visit':
        return StepContentSiteVisit(activity: activity);
      case 'sample-analysis':
        return StepContentSampleAnalysis(activity: activity);
      case 'reports':
        return StepContentMapReport(activity: activity);
      case 'preserve':
        return StepContentPreserve(
          activity: activity,
          isSubmitting: ctrl.preserveSubmitting,
          onSendToArchive: (p) => ctrl.submitPreserveSpecimens(
            activity.id,
            specimenCount: p.specimenCount,
            specimenType: p.specimenType,
            destination: p.destination,
            notes: p.notes,
          ),
        );
      default:
        return _StepContentPlaceholder(
          stepId: selectedStep.id,
          stepTitle: selectedStep.title,
        );
    }
  }
}

class _DetailHeader extends StatelessWidget {
  const _DetailHeader({required this.activity});

  final MappingActivityEntity activity;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          activity.activityName,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${activity.id} • ${activity.location}',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _StatusChip(status: activity.status),
            const SizedBox(width: 12),
            FilledButton.icon(
              onPressed: () => context.push(
                '/geoscientific-survey/mapping/${activity.id}/edit',
              ),
              icon: const Icon(Icons.edit_outlined, size: 18),
              label: const Text('Edit'),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isCompleted = status == 'Completed';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isCompleted
            ? theme.colorScheme.primaryContainer
            : theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: theme.textTheme.labelLarge?.copyWith(
          color: isCompleted
              ? theme.colorScheme.onPrimaryContainer
              : theme.colorScheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// Placeholder for step-specific content. Replace with real step content in TODOs 9–14.
class _StepContentPlaceholder extends StatelessWidget {
  const _StepContentPlaceholder({
    required this.stepId,
    required this.stepTitle,
  });

  final String stepId;
  final String stepTitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              stepTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Content for this step will be implemented in the next tasks.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
