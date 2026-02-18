import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../domain/entities/mapping_activity_entity.dart';

/// Step content: Final Upload – upload raw data, reports, and geological map in approved formats.
/// Enabled only when [activity.isEditorialApproved]. Auth enforced at API layer.
class StepContentFinalUpload extends StatefulWidget {
  const StepContentFinalUpload({
    super.key,
    required this.activity,
    required this.onCompleteFinalUpload,
    this.isSubmitting = false,
  });

  final MappingActivityEntity activity;
  final VoidCallback onCompleteFinalUpload;
  final bool isSubmitting;

  @override
  State<StepContentFinalUpload> createState() => _StepContentFinalUploadState();
}

class _StepContentFinalUploadState extends State<StepContentFinalUpload> {
  PlatformFile? _rawDataFile;
  PlatformFile? _reportFile;
  PlatformFile? _mapFile;

  static const List<String> _dataExtensions = ['csv', 'zip', 'shp', 'geojson'];
  static const List<String> _reportExtensions = ['pdf', 'doc', 'docx'];
  static const List<String> _mapExtensions = ['pdf', 'tif', 'tiff', 'geotiff'];

  Future<void> _pickFile(
    List<String> extensions,
    void Function(PlatformFile?) setFile,
  ) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: extensions,
      withData: false,
    );
    if (result == null || result.files.isEmpty) return;
    final file = result.files.single;
    if (file.name.isEmpty) return;
    setState(() => setFile(file));
  }

  void _submit() {
    widget.onCompleteFinalUpload();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Final upload recorded. Files will be sent when backend is connected.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final approved = widget.activity.isEditorialApproved;
    final completed = widget.activity.finalUploadDate != null &&
        widget.activity.finalUploadDate!.isNotEmpty;

    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Final Upload',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Upload final raw data, report, and geological map in approved formats after editorial approval.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 24),
          if (!approved) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: theme.colorScheme.primary, size: 22),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Editorial must approve the draft before you can complete the final upload. Go to the Editorial Submission step first.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ] else if (completed) ...[
            Row(
              children: [
                Icon(Icons.check_circle_outline, color: theme.colorScheme.primary, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Final upload completed on ${widget.activity.finalUploadDate}.',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ] else ...[
            Text(
              'Approved formats',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Raw data: CSV, ZIP, SHP, GeoJSON\nReport: PDF, DOC, DOCX\nGeological map: PDF, GeoTIFF',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
              ),
            ),
            const SizedBox(height: 20),
            OutlinedButton.icon(
              onPressed: widget.isSubmitting
                  ? null
                  : () => _pickFile(_dataExtensions, (f) => _rawDataFile = f),
              icon: const Icon(Icons.attach_file, size: 18),
              label: Text(_rawDataFile?.name ?? 'Select raw data file'),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: widget.isSubmitting
                  ? null
                  : () => _pickFile(_reportExtensions, (f) => _reportFile = f),
              icon: const Icon(Icons.description_outlined, size: 18),
              label: Text(_reportFile?.name ?? 'Select report file'),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: widget.isSubmitting
                  ? null
                  : () => _pickFile(_mapExtensions, (f) => _mapFile = f),
              icon: const Icon(Icons.map_outlined, size: 18),
              label: Text(_mapFile?.name ?? 'Select geological map file'),
            ),
            const SizedBox(height: 24),
            AppButton(
              onPressed: widget.isSubmitting ? null : _submit,
              child: Text(widget.isSubmitting ? 'Completing...' : 'Complete final upload'),
            ),
          ],
        ],
      ),
    );
  }
}
