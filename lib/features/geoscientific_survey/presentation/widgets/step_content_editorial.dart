import 'package:flutter/material.dart';

import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../domain/entities/mapping_activity_entity.dart';

/// Step content: Editorial Submission – submit draft to editorial; show status (submitted / returned / approved).
/// Caller provides [onSubmitToEditorial] and [onNavigateToStep] for actions; auth enforced at API layer.
class StepContentEditorial extends StatelessWidget {
  const StepContentEditorial({
    super.key,
    required this.activity,
    required this.onSubmitToEditorial,
    required this.onNavigateToStep,
    this.isSubmitting = false,
  });

  final MappingActivityEntity activity;
  final VoidCallback onSubmitToEditorial;
  final void Function(String stepId) onNavigateToStep;
  final bool isSubmitting;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final status = activity.editorialStatus;

    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Editorial Submission',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Submit draft map and report to the editorial team. They may approve or return for corrections.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 24),
          if (status == null || status.isEmpty) ...[
            Text(
              'Draft must be uploaded in the "Draft Map & Report" step before submission.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
              ),
            ),
            const SizedBox(height: 20),
            AppButton(
              onPressed: isSubmitting || !activity.reportsGenerated ? null : () => onSubmitToEditorial(),
              child: Text(isSubmitting ? 'Submitting...' : 'Submit to Editorial'),
            ),
          ] else if (status == 'draft_submitted') ...[
            Row(
              children: [
                Icon(Icons.schedule_outlined, color: theme.colorScheme.primary, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Submitted. Awaiting editorial review.',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ] else if (status == 'returned') ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.errorContainer.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.feedback_outlined, color: theme.colorScheme.error, size: 22),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Corrections requested. Please update the draft map and report, then resubmit.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            AppButton(
              onPressed: () => onNavigateToStep('reports'),
              variant: AppButtonVariant.secondary,
              child: const Text('Make corrections'),
            ),
          ] else if (status == 'approved') ...[
            Row(
              children: [
                Icon(Icons.check_circle_outline, color: theme.colorScheme.primary, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Approved. You can proceed to Final Upload.',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            AppButton(
              onPressed: () => onNavigateToStep('final-upload'),
              child: const Text('Proceed to Final Upload'),
            ),
          ] else ...[
            Text(
              'Status: $status',
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ],
      ),
    );
  }
}
