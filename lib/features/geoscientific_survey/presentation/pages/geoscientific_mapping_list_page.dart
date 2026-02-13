import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_scaffold.dart';
import '../../../../shared/widgets/app_button.dart';

class GeoscientificMappingListPage extends StatelessWidget {
  const GeoscientificMappingListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppScaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Geoscientific Survey  >  Mapping activity',
              style: theme.textTheme.bodySmall?.copyWith(
                color:
                    theme.colorScheme.onSurface.withValues(alpha: 0.7),
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
                color:
                    theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: AppButton(
                onPressed: () =>
                    context.push('/geoscientific-survey/mapping/new'),
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
            ),
            const SizedBox(height: 16),
            AppCard(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: const Icon(Icons.search),
                  hintText: 'Search mapping activities...',
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: AppCard(
                padding: EdgeInsets.zero,
                child: _MappingTable(),
              ),
            ),
            const SizedBox(height: 8),
            const _TableFooter(),
          ],
        ),
      ),
    );
  }
}

class _MappingTable extends StatelessWidget {
  final List<_MappingRow> rows = const [
    _MappingRow(
      name: 'Coastal Geological Mapping',
      type: 'Internal',
      surveyType: 'Geological',
      location: 'Geita',
    ),
    _MappingRow(
      name: 'Granite Zone Mapping',
      type: 'Consultancy',
      surveyType: 'Geological',
      location: 'Meru',
    ),
    _MappingRow(
      name: 'Regional Geochemical Survey',
      type: 'Internal',
      surveyType: 'Geochemical',
      location: 'Lake',
    ),
    _MappingRow(
      name: 'Hazard Assessment',
      type: 'Internal',
      surveyType: 'Geohazard',
      location: 'Dodoma',
    ),
    _MappingRow(
      name: 'Magnetic Survey',
      type: 'Consultancy',
      surveyType: 'Geophysical',
      location: 'Tanga',
    ),
    _MappingRow(
      name: 'Shear Belt Mapping',
      type: 'Internal',
      surveyType: 'Geological',
      location: 'Kigoma',
    ),
    _MappingRow(
      name: 'Deep Earth Exploration',
      type: 'Internal',
      surveyType: 'Geochemical',
      location: 'Singida',
    ),
    _MappingRow(
      name: 'Seismic Study',
      type: 'Consultancy',
      surveyType: 'Geophysical',
      location: 'Kilimanjaro',
    ),
  ];

  _MappingTable({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final headerStyle = theme.textTheme.bodySmall!.copyWith(
      fontWeight: FontWeight.w600,
      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
    );

    final rowStyle = theme.textTheme.bodySmall!;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 700),
        child: SingleChildScrollView(
          child: DataTable(
            headingRowHeight: 44,
            dataRowMinHeight: 40,
            dataRowMaxHeight: 44,
            columns: [
              DataColumn(label: Text('Activity Name', style: headerStyle)),
              DataColumn(
                label: Row(
                  children: [
                    Text('Type', style: headerStyle),
                    const SizedBox(width: 4),
                    const Icon(Icons.unfold_more, size: 16),
                  ],
                ),
              ),
              DataColumn(
                label: Row(
                  children: [
                    Text('Survey Type', style: headerStyle),
                    const SizedBox(width: 4),
                    const Icon(Icons.unfold_more, size: 16),
                  ],
                ),
              ),
              DataColumn(
                label: Row(
                  children: [
                    Text('Location', style: headerStyle),
                    const SizedBox(width: 4),
                    const Icon(Icons.unfold_more, size: 16),
                  ],
                ),
              ),
            ],
            rows: rows
                .map(
                  (e) => DataRow(
                    cells: [
                      DataCell(Text(e.name, style: rowStyle)),
                      DataCell(_TypeChip(label: e.type)),
                      DataCell(Text(e.surveyType, style: rowStyle)),
                      DataCell(Text(e.location, style: rowStyle)),
                    ],
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}

class _TypeChip extends StatelessWidget {
  final String label;

  const _TypeChip({required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isInternal = label.toLowerCase() == 'internal';

    final Color background = isInternal
        ? theme.colorScheme.primary.withValues(alpha: 0.1)
        : theme.colorScheme.secondary.withValues(alpha: 0.7);

    final Color foreground = isInternal
        ? theme.colorScheme.primary
        : theme.colorScheme.onSecondary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: foreground,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _MappingRow {
  final String name;
  final String type;
  final String surveyType;
  final String location;

  const _MappingRow({
    required this.name,
    required this.type,
    required this.surveyType,
    required this.location,
  });
}

class _TableFooter extends StatelessWidget {
  const _TableFooter();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Text(
          'Showing 1–8 of 8',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: theme.colorScheme.outlineVariant),
          ),
          child: Row(
            children: [
              Text(
                '10',
                style: theme.textTheme.bodySmall,
              ),
              const Icon(Icons.arrow_drop_down, size: 18),
            ],
          ),
        ),
        const SizedBox(width: 12),
        IconButton(
          visualDensity: VisualDensity.compact,
          onPressed: () {},
          icon: const Icon(Icons.first_page),
        ),
        IconButton(
          visualDensity: VisualDensity.compact,
          onPressed: () {},
          icon: const Icon(Icons.chevron_left),
        ),
        IconButton(
          visualDensity: VisualDensity.compact,
          onPressed: () {},
          icon: const Icon(Icons.chevron_right),
        ),
        IconButton(
          visualDensity: VisualDensity.compact,
          onPressed: () {},
          icon: const Icon(Icons.last_page),
        ),
      ],
    );
  }
}

