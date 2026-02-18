import 'package:flutter/material.dart';

import '../../../../shared/widgets/app_card.dart';
import '../../domain/entities/mapping_activity_entity.dart';

/// Lightweight model for a sample analysis request (UI + future API).
class SampleRequestItem {
  const SampleRequestItem({
    required this.id,
    required this.sampleId,
    required this.sampleType,
    required this.analysisType,
    required this.dateSubmitted,
    required this.status,
    required this.hasResults,
    this.results,
    this.labNotes,
  });

  final String id;
  final String sampleId;
  final String sampleType;
  final String analysisType;
  final String dateSubmitted;
  final String status; // 'completed' | 'in_progress'
  final bool hasResults;
  final Map<String, String>? results;
  final String? labNotes;
}

/// Step content: Sample Analysis – list of sample requests, New Sample Request form,
/// View Results opens a bottom sheet with sample info and result fields.
class StepContentSampleAnalysis extends StatefulWidget {
  const StepContentSampleAnalysis({
    super.key,
    required this.activity,
    this.requests = const [],
    this.onSubmitRequest,
  });

  final MappingActivityEntity activity;
  /// Initial list (e.g. from controller when API exists). If empty, mock data is used for UI.
  final List<SampleRequestItem> requests;
  /// Called when user submits a new sample request (for future API integration).
  final void Function({
    required String sampleId,
    required String sampleType,
    required String analysisType,
    required String dateSubmitted,
    String? labNotes,
  })? onSubmitRequest;

  @override
  State<StepContentSampleAnalysis> createState() =>
      _StepContentSampleAnalysisState();
}

class _StepContentSampleAnalysisState extends State<StepContentSampleAnalysis> {
  late List<SampleRequestItem> _requests;
  bool _showNewForm = false;
  final _sampleIdController = TextEditingController();
  final _sampleTypeController = TextEditingController();
  final _analysisTypeController = TextEditingController();
  final _dateController = TextEditingController();
  final _labNotesController = TextEditingController();

  static List<SampleRequestItem> _mockRequests() => [
        SampleRequestItem(
          id: 'SR-001',
          sampleId: 'SAMPLE-2024-001',
          sampleType: 'Rock',
          analysisType: 'Geochemical',
          dateSubmitted: '2024-01-15',
          status: 'completed',
          hasResults: true,
          results: {
            'pH': '7.2',
            'mineralContent': 'Quartz 45%, Feldspar 30%, Mica 25%',
            'chemicalComposition': 'SiO2: 65%, Al2O3: 15%, Fe2O3: 8%',
            'notes': 'Sample shows typical granitic composition',
          },
        ),
        SampleRequestItem(
          id: 'SR-002',
          sampleId: 'SAMPLE-2024-002',
          sampleType: 'Soil',
          analysisType: 'Geochemical',
          dateSubmitted: '2024-01-16',
          status: 'in_progress',
          hasResults: false,
        ),
        SampleRequestItem(
          id: 'SR-003',
          sampleId: 'SAMPLE-2024-003',
          sampleType: 'Water',
          analysisType: 'Chemical',
          dateSubmitted: '2024-01-17',
          status: 'completed',
          hasResults: true,
          results: {
            'pH': '6.8',
            'turbidity': '5 NTU',
            'dissolvedOxygen': '8.2 mg/L',
            'notes': 'Water quality within acceptable parameters',
          },
        ),
      ];

  @override
  void initState() {
    super.initState();
    _requests = widget.requests.isEmpty ? _mockRequests() : List.from(widget.requests);
  }

  @override
  void dispose() {
    _sampleIdController.dispose();
    _sampleTypeController.dispose();
    _analysisTypeController.dispose();
    _dateController.dispose();
    _labNotesController.dispose();
    super.dispose();
  }

  void _handleSubmitRequest() {
    final sampleId = _sampleIdController.text.trim();
    final sampleType = _sampleTypeController.text.trim();
    final analysisType = _analysisTypeController.text.trim();
    final dateSubmitted = _dateController.text.trim();
    if (sampleId.isEmpty || sampleType.isEmpty || analysisType.isEmpty || dateSubmitted.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill Sample ID, Type, Analysis Type, and Date')),
        );
      }
      return;
    }
    widget.onSubmitRequest?.call(
      sampleId: sampleId,
      sampleType: sampleType,
      analysisType: analysisType,
      dateSubmitted: dateSubmitted,
      labNotes: _labNotesController.text.trim().isEmpty ? null : _labNotesController.text.trim(),
    );
    setState(() {
      _showNewForm = false;
      _sampleIdController.clear();
      _sampleTypeController.clear();
      _analysisTypeController.clear();
      _dateController.clear();
      _labNotesController.clear();
      // When API exists, append from response; for now keep mock list
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Request will be sent when backend is connected.')),
      );
    }
  }

  void _openResultsSheet(SampleRequestItem request) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => _SampleResultsSheet(request: request),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: AppCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.science_outlined, size: 22, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Sample Analysis',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                FilledButton.tonalIcon(
                  onPressed: () => setState(() => _showNewForm = !_showNewForm),
                  icon: Icon(_showNewForm ? Icons.close : Icons.add, size: 20),
                  label: Text(_showNewForm ? 'Cancel' : 'New Sample Request'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_showNewForm) ...[
              _NewSampleForm(
                sampleIdController: _sampleIdController,
                sampleTypeController: _sampleTypeController,
                analysisTypeController: _analysisTypeController,
                dateController: _dateController,
                labNotesController: _labNotesController,
                onSubmit: _handleSubmitRequest,
                onCancel: () => setState(() => _showNewForm = false),
              ),
              const SizedBox(height: 20),
            ],
            Text(
              'Sample Requests',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            if (_requests.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: Text(
                    'No sample requests yet',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _requests.length,
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final r = _requests[index];
                  return _RequestCard(
                    request: r,
                    onViewResults: r.hasResults ? () => _openResultsSheet(r) : null,
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _NewSampleForm extends StatelessWidget {
  const _NewSampleForm({
    required this.sampleIdController,
    required this.sampleTypeController,
    required this.analysisTypeController,
    required this.dateController,
    required this.labNotesController,
    required this.onSubmit,
    required this.onCancel,
  });

  final TextEditingController sampleIdController;
  final TextEditingController sampleTypeController;
  final TextEditingController analysisTypeController;
  final TextEditingController dateController;
  final TextEditingController labNotesController;
  final VoidCallback onSubmit;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Submit New Sample',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: sampleIdController,
            decoration: const InputDecoration(
              labelText: 'Sample ID',
              hintText: 'e.g. SAMPLE-2024-004',
              border: OutlineInputBorder(),
            ),
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 10),
          TextField(
            controller: sampleTypeController,
            decoration: const InputDecoration(
              labelText: 'Sample Type',
              hintText: 'e.g. Rock, Soil, Water',
              border: OutlineInputBorder(),
            ),
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 10),
          TextField(
            controller: analysisTypeController,
            decoration: const InputDecoration(
              labelText: 'Analysis Type',
              hintText: 'e.g. Geochemical',
              border: OutlineInputBorder(),
            ),
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 10),
          TextField(
            controller: dateController,
            decoration: const InputDecoration(
              labelText: 'Date Submitted',
              border: OutlineInputBorder(),
            ),
            readOnly: true,
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
              );
              if (date != null) dateController.text = _formatDate(date);
            },
          ),
          const SizedBox(height: 10),
          TextField(
            controller: labNotesController,
            decoration: const InputDecoration(
              labelText: 'Laboratory Notes',
              hintText: 'Special instructions for laboratory...',
              border: OutlineInputBorder(),
              alignLabelWithHint: true,
            ),
            maxLines: 2,
            textInputAction: TextInputAction.newline,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              FilledButton.icon(
                onPressed: onSubmit,
                icon: const Icon(Icons.science_outlined, size: 18),
                label: const Text('Submit Request'),
              ),
              const SizedBox(width: 8),
              OutlinedButton(
                onPressed: onCancel,
                child: const Text('Cancel'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

String _formatDate(DateTime d) =>
    '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

class _RequestCard extends StatelessWidget {
  const _RequestCard({
    required this.request,
    this.onViewResults,
  });

  final SampleRequestItem request;
  final VoidCallback? onViewResults;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  request.id,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: request.status == 'completed'
                        ? theme.colorScheme.primaryContainer
                        : theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    request.status == 'completed' ? 'Completed' : 'In Progress',
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text('${request.sampleId} · ${request.sampleType} · ${request.analysisType}',
                style: theme.textTheme.bodySmall),
            const SizedBox(height: 4),
            Text(
              'Submitted ${request.dateSubmitted}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            if (onViewResults != null) ...[
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: onViewResults,
                  icon: const Icon(Icons.visibility_outlined, size: 18),
                  label: const Text('View Results'),
                ),
              ),
            ] else
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  'No results yet',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SampleResultsSheet extends StatelessWidget {
  const _SampleResultsSheet({required this.request});

  final SampleRequestItem request;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) => SingleChildScrollView(
        controller: scrollController,
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.science_outlined, size: 22, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Sample Analysis Results',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Results for ${request.sampleId}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 16),
            AppCard(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sample Information',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _InfoRow(label: 'Request ID', value: request.id),
                  _InfoRow(label: 'Sample ID', value: request.sampleId),
                  _InfoRow(label: 'Sample Type', value: request.sampleType),
                  _InfoRow(label: 'Analysis Type', value: request.analysisType),
                  _InfoRow(label: 'Date Submitted', value: request.dateSubmitted),
                  _InfoRow(label: 'Status', value: request.status),
                ],
              ),
            ),
            const SizedBox(height: 12),
            if (request.hasResults && request.results != null && request.results!.isNotEmpty) ...[
              AppCard(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Analysis Results',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...request.results!.entries.map(
                      (e) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _labelFromKey(e.key),
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(e.value, style: theme.textTheme.bodyMedium),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ] else
              AppCard(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.schedule_outlined,
                        size: 40,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Results Not Available Yet',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'The laboratory is still processing this sample.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _labelFromKey(String key) {
  final buffer = StringBuffer();
  for (var i = 0; i < key.length; i++) {
    final c = key[i];
    if (i > 0 && c == c.toUpperCase() && c.toLowerCase() != c) buffer.write(' ');
    buffer.write(i == 0 ? c.toUpperCase() : c.toLowerCase());
  }
  return buffer.toString();
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ),
          Expanded(child: Text(value, style: theme.textTheme.bodyMedium)),
        ],
      ),
    );
  }
}
