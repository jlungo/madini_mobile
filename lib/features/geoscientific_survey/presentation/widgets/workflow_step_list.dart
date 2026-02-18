import 'package:flutter/material.dart';

import '../../domain/entities/mapping_activity_entity.dart';

enum WorkflowStepStatus { completed, current, pending }

class WorkflowStep {
  const WorkflowStep({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.icon,
  });

  final String id;
  final String title;
  final String description;
  final WorkflowStepStatus status;
  final IconData icon;
}

/// Builds the ordered list of workflow steps for a mapping activity (process-flow aligned).
/// Order: Activity Details → Deskwork → Basemap → Site Visit → [Sample Analysis] → Preserve → Draft Map & Report → Editorial → Final Upload.
/// Sample Analysis is included only when [activity.samplesCollected] is true.
List<WorkflowStep> buildWorkflowSteps(MappingActivityEntity activity) {
  const statusOrder = [
    'Planned',
    'Ready for Site Visit',
    'On-site Data Collection',
    'Awaiting Lab Results',
    'Lab Results Received',
    'Map & Report Preparation',
    'Completed',
  ];
  final currentIndex = statusOrder.indexOf(activity.status);
  final steps = <WorkflowStep>[];

  // 1. Activity Details
  steps.add(const WorkflowStep(
    id: 'create',
    title: 'Activity Details',
    description: 'Activity metadata captured',
    status: WorkflowStepStatus.completed,
    icon: Icons.description_outlined,
  ));

  // 2. Deskwork (literature, satellite, spatial overlay)
  steps.add(WorkflowStep(
    id: 'deskwork',
    title: 'Deskwork',
    description: 'Literature review, satellite data, spatial overlay',
    status: activity.deskworkCompleted
        ? WorkflowStepStatus.completed
        : (currentIndex == 0 ? WorkflowStepStatus.current : WorkflowStepStatus.pending),
    icon: Icons.library_books_outlined,
  ));

  // 3. Basemap
  steps.add(WorkflowStep(
    id: 'basemap',
    title: 'Basemap',
    description: 'Base map prepared and uploaded',
    status: activity.basemapUploaded
        ? WorkflowStepStatus.completed
        : (currentIndex == 0 ? WorkflowStepStatus.current : WorkflowStepStatus.pending),
    icon: Icons.map_outlined,
  ));

  // 4. Site Visit & Data Collection
  steps.add(WorkflowStep(
    id: 'site-visit',
    title: 'Site Visit & Data Collection',
    description: 'On-site survey and data collection',
    status: currentIndex >= 2
        ? WorkflowStepStatus.completed
        : (currentIndex == 1 || activity.status == 'Ready for Site Visit'
            ? WorkflowStepStatus.current
            : WorkflowStepStatus.pending),
    icon: Icons.camera_alt_outlined,
  ));

  // 5. Sample Analysis (conditional)
  if (activity.samplesCollected) {
    steps.add(WorkflowStep(
      id: 'sample-analysis',
      title: 'Sample Analysis',
      description: 'Laboratory submission and results',
      status: currentIndex >= 5
          ? WorkflowStepStatus.completed
          : (currentIndex == 3 ||
                  currentIndex == 4 ||
                  activity.status == 'Awaiting Lab Results' ||
                  activity.status == 'Lab Results Received'
              ? WorkflowStepStatus.current
              : WorkflowStepStatus.pending),
      icon: Icons.science_outlined,
    ));
  }

  // 6. Preserve Specimens (Museum)
  steps.add(WorkflowStep(
    id: 'preserve',
    title: 'Preserve Specimens',
    description: 'Archive physical specimens',
    status: activity.status == 'Completed'
        ? WorkflowStepStatus.completed
        : WorkflowStepStatus.pending,
    icon: Icons.account_balance_outlined,
  ));

  // 7. Draft Map & Report
  steps.add(WorkflowStep(
    id: 'reports',
    title: 'Draft Map & Report',
    description: 'Upload draft map and report',
    status: activity.reportsGenerated
        ? WorkflowStepStatus.completed
        : (activity.status == 'Map & Report Preparation'
            ? WorkflowStepStatus.current
            : WorkflowStepStatus.pending),
    icon: Icons.upload_file_outlined,
  ));

  // 8. Editorial Submission
  final editorialStatus = activity.editorialStatus;
  steps.add(WorkflowStep(
    id: 'editorial',
    title: 'Editorial Submission',
    description: 'Submit draft to editorial; returned or approved',
    status: editorialStatus == 'approved' || editorialStatus == 'returned'
        ? WorkflowStepStatus.completed
        : (editorialStatus == 'draft_submitted'
            ? WorkflowStepStatus.current
            : WorkflowStepStatus.pending),
    icon: Icons.rate_review_outlined,
  ));

  // 9. Final Upload (gated by editorial approval)
  final hasFinalUpload = activity.finalUploadDate != null && activity.finalUploadDate!.isNotEmpty;
  steps.add(WorkflowStep(
    id: 'final-upload',
    title: 'Final Upload',
    description: 'Upload final data and map in approved formats',
    status: hasFinalUpload
        ? WorkflowStepStatus.completed
        : (activity.isEditorialApproved ? WorkflowStepStatus.current : WorkflowStepStatus.pending),
    icon: Icons.cloud_upload_outlined,
  ));

  return steps;
}

/// Vertical list of workflow steps. Tapping a step reports [onStepSelected].
class WorkflowStepList extends StatelessWidget {
  const WorkflowStepList({
    super.key,
    required this.steps,
    required this.selectedStepId,
    required this.onStepSelected,
  });

  final List<WorkflowStep> steps;
  final String selectedStepId;
  final ValueChanged<String> onStepSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < steps.length; i++) ...[
          _StepTile(
            step: steps[i],
            isSelected: steps[i].id == selectedStepId,
            onTap: () => onStepSelected(steps[i].id),
          ),
          if (i < steps.length - 1)
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Container(
                width: 2,
                height: 12,
                color: theme.colorScheme.outlineVariant,
              ),
            ),
        ],
      ],
    );
  }
}

class _StepTile extends StatelessWidget {
  const _StepTile({
    required this.step,
    required this.isSelected,
    required this.onTap,
  });

  final WorkflowStep step;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPending = step.status == WorkflowStepStatus.pending;

    Color iconBg;
    Color iconFg;
    switch (step.status) {
      case WorkflowStepStatus.completed:
        iconBg = theme.colorScheme.primaryContainer;
        iconFg = theme.colorScheme.onPrimaryContainer;
        break;
      case WorkflowStepStatus.current:
        iconBg = theme.colorScheme.secondaryContainer;
        iconFg = theme.colorScheme.onSecondaryContainer;
        break;
      case WorkflowStepStatus.pending:
        iconBg = theme.colorScheme.surfaceContainerHighest;
        iconFg = theme.colorScheme.onSurface.withValues(alpha: 0.5);
        break;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconBg,
                shape: BoxShape.circle,
              ),
              child: Icon(step.icon, size: 22, color: iconFg),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          step.title,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w500,
                            color: isPending
                                ? theme.colorScheme.onSurface.withValues(alpha: 0.6)
                                : null,
                          ),
                        ),
                      ),
                      if (step.status == WorkflowStepStatus.completed)
                        Icon(
                          Icons.check_circle_outline,
                          size: 20,
                          color: theme.colorScheme.primary,
                        ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    step.description,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
