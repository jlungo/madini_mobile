import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/widgets/app_scaffold.dart';

/// Placeholder for mapping activity edit. Replace with full form in TODO 6.
class MappingActivityEditPlaceholderPage extends StatelessWidget {
  const MappingActivityEditPlaceholderPage({super.key, required this.activityId});

  final String activityId;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Edit Mapping Activity',
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Edit: $activityId', style: Theme.of(context).textTheme.titleMedium),
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
