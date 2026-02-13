import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_input.dart';
import '../../../../shared/widgets/app_scaffold.dart';

class GeoscientificMappingCreatePage extends StatelessWidget {
  const GeoscientificMappingCreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppScaffold(
      body: Stack(
        children: [
          Container(
            color: Colors.black.withOpacity(0.2),
          ),
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
                            onPressed: () => context.pop(),
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
                      const AppInput(
                        label: 'Activity Name *',
                        hintText: 'Enter activity name',
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: const [
                          Expanded(
                            child: _DropdownField(
                              label: 'Activity Type *',
                              value: 'Internal',
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: _DropdownField(
                              label: 'Survey Type *',
                              value: 'Geological',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const AppInput(
                        label: 'Location *',
                        hintText: 'Enter location',
                      ),
                      const SizedBox(height: 16),
                      const AppInput(
                        label: 'Lead Scientist *',
                        hintText: 'Enter lead scientist name',
                      ),
                      const SizedBox(height: 16),
                      const _DateField(),
                      const SizedBox(height: 24),
                      AppButton(
                        onPressed: () {},
                        fullWidth: true,
                        child: Text(
                          'Create Activity',
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: theme.colorScheme.onPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      AppButton(
                        onPressed: () => context.pop(),
                        fullWidth: true,
                        variant: AppButtonVariant.secondary,
                        child: Text(
                          'Cancel',
                          style: theme.textTheme.labelLarge,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DropdownField extends StatelessWidget {
  final String label;
  final String value;

  const _DropdownField({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall,
        ),
        const SizedBox(height: 4),
        InputDecorator(
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                value,
                style: theme.textTheme.bodyMedium,
              ),
              const Icon(Icons.arrow_drop_down),
            ],
          ),
        ),
      ],
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Created Date',
          style: theme.textTheme.bodySmall,
        ),
        const SizedBox(height: 4),
        TextField(
          readOnly: true,
          decoration: InputDecoration(
            hintText: '02/11/2026',
            suffixIcon: const Icon(Icons.calendar_today_outlined),
          ),
        ),
      ],
    );
  }
}

