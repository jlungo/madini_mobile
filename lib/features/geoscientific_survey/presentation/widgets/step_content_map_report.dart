import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../../../shared/widgets/app_card.dart';
import '../../domain/entities/mapping_activity_entity.dart';

/// Step content: Map & Report – upload geological map and final report files,
/// optional summary text; shows Uploaded state when [activity.reportsGenerated].
class StepContentMapReport extends StatefulWidget {
  const StepContentMapReport({
    super.key,
    required this.activity,
    this.onUpload,
    this.onReplace,
  });

  final MappingActivityEntity activity;
  /// Called when user taps Upload (map + report files, summary) for future API.
  final void Function({
    PlatformFile? mapFile,
    PlatformFile? reportFile,
    String? summary,
  })? onUpload;
  /// Called when user taps Replace (for future API).
  final void Function({
    PlatformFile? mapFile,
    PlatformFile? reportFile,
    String? summary,
  })? onReplace;

  @override
  State<StepContentMapReport> createState() => _StepContentMapReportState();
}

class _StepContentMapReportState extends State<StepContentMapReport> {
  PlatformFile? _mapFile;
  PlatformFile? _reportFile;
  final _summaryController = TextEditingController();
  /// When true, show upload form even if activity.reportsGenerated (user tapped Replace).
  bool _showFormForReplace = false;

  static const List<String> _mapExtensions = ['pdf', 'jpg', 'jpeg', 'png'];
  static const List<String> _reportExtensions = ['pdf', 'doc', 'docx'];

  @override
  void dispose() {
    _summaryController.dispose();
    super.dispose();
  }

  Future<void> _pickMap() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: _mapExtensions,
      withData: false,
    );
    if (result == null || result.files.isEmpty) return;
    final file = result.files.single;
    if (file.name.isEmpty) return;
    setState(() => _mapFile = file);
  }

  Future<void> _pickReport() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: _reportExtensions,
      withData: false,
    );
    if (result == null || result.files.isEmpty) return;
    final file = result.files.single;
    if (file.name.isEmpty) return;
    setState(() => _reportFile = file);
  }

  void _handleUpload() {
    if (_mapFile == null && _reportFile == null) return;
    widget.onUpload?.call(
      mapFile: _mapFile,
      reportFile: _reportFile,
      summary: _summaryController.text.trim().isEmpty
          ? null
          : _summaryController.text.trim(),
    );
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Upload will be sent when backend is connected.'),
      ),
    );
  }

  void _startReplace() {
    setState(() {
      _showFormForReplace = true;
      _mapFile = null;
      _reportFile = null;
      _summaryController.clear();
    });
    widget.onReplace?.call(mapFile: null, reportFile: null, summary: null);
  }

  void _handleReplaceUpload() {
    if (_mapFile == null && _reportFile == null) return;
    widget.onReplace?.call(
      mapFile: _mapFile,
      reportFile: _reportFile,
      summary: _summaryController.text.trim().isEmpty
          ? null
          : _summaryController.text.trim(),
    );
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Replace will be sent when backend is connected.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activity = widget.activity;

    return SingleChildScrollView(
      child: AppCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.map_outlined, size: 22, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Upload Maps and Reports',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (activity.reportsGenerated && !_showFormForReplace) ...[
              _UploadedState(activity: activity),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: _startReplace,
                icon: const Icon(Icons.upload_outlined, size: 20),
                label: const Text('Replace Maps & Reports'),
              ),
            ] else ...[
              _FilePickerRow(
                label: 'Geological Map',
                hint: 'Upload the final geological map',
                extensions: 'PDF, JPG, PNG',
                file: _mapFile,
                onPick: _pickMap,
              ),
              const SizedBox(height: 14),
              _FilePickerRow(
                label: 'Final Report',
                hint: 'Upload the comprehensive survey report',
                extensions: 'PDF, DOC, DOCX',
                file: _reportFile,
                onPick: _pickReport,
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _summaryController,
                decoration: const InputDecoration(
                  labelText: 'Report Summary',
                  hintText: 'Brief summary of findings...',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: 4,
                textInputAction: TextInputAction.newline,
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: (_mapFile != null || _reportFile != null)
                    ? (_showFormForReplace ? _handleReplaceUpload : _handleUpload)
                    : null,
                icon: const Icon(Icons.upload_outlined, size: 20),
                label: Text(
                  _showFormForReplace ? 'Replace Maps & Reports' : 'Upload Maps & Reports',
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _UploadedState extends StatelessWidget {
  const _UploadedState({required this.activity});

  final MappingActivityEntity activity;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle_outline, size: 28, color: theme.colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Maps & Reports',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'map_report_${activity.id}.pdf',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle_outline, size: 16, color: theme.colorScheme.primary),
                const SizedBox(width: 6),
                Text(
                  'Uploaded',
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FilePickerRow extends StatelessWidget {
  const _FilePickerRow({
    required this.label,
    required this.hint,
    required this.extensions,
    this.file,
    required this.onPick,
  });

  final String label;
  final String hint;
  final String extensions;
  final PlatformFile? file;
  final VoidCallback onPick;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelLarge,
        ),
        const SizedBox(height: 6),
        OutlinedButton.icon(
          onPressed: onPick,
          icon: const Icon(Icons.folder_open_outlined, size: 20),
          label: Text(file?.name ?? 'Choose file'),
        ),
        if (file != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              file!.name,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ),
        const SizedBox(height: 4),
        Text(
          '$hint · $extensions',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }
}
