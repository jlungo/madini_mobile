import 'package:flutter/material.dart';

import '../../../../shared/widgets/app_card.dart';
import '../../domain/entities/mapping_activity_entity.dart';

bool _isFromEoffice(MappingActivityEntity a) {
  return (a.source?.toLowerCase() == 'eoffice') || a.approvedByEoffice;
}

/// Step content: Activity Details – read-only summary and progress badges.
class StepContentActivityDetails extends StatelessWidget {
  const StepContentActivityDetails({super.key, required this.activity});

  final MappingActivityEntity activity;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mutedLabel = theme.textTheme.bodySmall?.copyWith(
      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
    );
    final valueStyle = theme.textTheme.bodyMedium?.copyWith(
      fontWeight: FontWeight.w500,
    );

    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Activity Details',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          if (_isFromEoffice(activity)) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: theme.colorScheme.primary.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.verified_outlined,
                    size: 20,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Source: eOffice (Approved)',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
          Wrap(
            spacing: 24,
            runSpacing: 16,
            children: [
              _ReadOnlyField(label: 'Activity Type', value: activity.activityType, labelStyle: mutedLabel, valueStyle: valueStyle),
              _ReadOnlyField(label: 'Survey Type', value: activity.surveyType, labelStyle: mutedLabel, valueStyle: valueStyle),
              _ReadOnlyField(label: 'Lead Scientist', value: activity.leadScientist, labelStyle: mutedLabel, valueStyle: valueStyle),
              _ReadOnlyField(label: 'Created Date', value: activity.createdDate, labelStyle: mutedLabel, valueStyle: valueStyle),
              if (activity.completedDate != null && activity.completedDate!.isNotEmpty)
                _ReadOnlyField(label: 'Completed Date', value: activity.completedDate!, labelStyle: mutedLabel, valueStyle: valueStyle),
            ],
          ),
          const SizedBox(height: 20),
          Divider(color: theme.colorScheme.outlineVariant),
          const SizedBox(height: 12),
          Text(
            'Progress Indicators',
            style: mutedLabel,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _ProgressBadge(
                label: 'Basemap',
                isDone: activity.basemapUploaded,
              ),
              _ProgressBadge(
                label: 'Samples',
                isDone: activity.samplesCollected,
              ),
              _ProgressBadge(
                label: 'Reports',
                isDone: activity.reportsGenerated,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ReadOnlyField extends StatelessWidget {
  const _ReadOnlyField({
    required this.label,
    required this.value,
    required this.labelStyle,
    required this.valueStyle,
  });

  final String label;
  final String value;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: labelStyle),
        const SizedBox(height: 2),
        Text(value, style: valueStyle),
      ],
    );
  }
}

class _ProgressBadge extends StatelessWidget {
  const _ProgressBadge({required this.label, required this.isDone});

  final String label;
  final bool isDone;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isDone
            ? theme.colorScheme.primaryContainer
            : theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
        border: isDone ? null : Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isDone ? Icons.check_circle_outline : Icons.schedule_outlined,
            size: 16,
            color: isDone
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: isDone
                  ? theme.colorScheme.onPrimaryContainer
                  : theme.colorScheme.onSurface.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}
