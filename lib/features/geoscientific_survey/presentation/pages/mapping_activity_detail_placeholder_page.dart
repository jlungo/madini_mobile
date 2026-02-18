import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/widgets/app_scaffold.dart';

/// Placeholder for mapping activity detail. Replace with full workflow in TODO 7.
class MappingActivityDetailPlaceholderPage extends StatelessWidget {
  const MappingActivityDetailPlaceholderPage({super.key, required this.activityId});

  final String activityId;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Mapping Activity',
      actions: [
        IconButton(
          icon: const Icon(Icons.edit_outlined),
          onPressed: () => context.push(
            '/geoscientific-survey/mapping/$activityId/edit',
          ),
        ),
      ],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Detail: $activityId', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => context.pop(),
                child: const Text('Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
