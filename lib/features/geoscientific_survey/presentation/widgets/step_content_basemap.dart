import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../../../shared/widgets/app_card.dart';
import '../../domain/entities/mapping_activity_entity.dart';

/// Step content: Basemap – upload or replace basemap file; shows Uploaded state when [activity.basemapUploaded].
class StepContentBasemap extends StatefulWidget {
  const StepContentBasemap({
    super.key,
    required this.activity,
    this.onUpload,
    this.onReplace,
  });

  final MappingActivityEntity activity;
  /// Called when user selects a file and taps Upload (for future API integration).
  final void Function(PlatformFile file)? onUpload;
  /// Called when user selects a file and taps Replace (for future API integration).
  final void Function(PlatformFile file)? onReplace;

  @override
  State<StepContentBasemap> createState() => _StepContentBasemapState();
}

class _StepContentBasemapState extends State<StepContentBasemap> {
  PlatformFile? _pickedFile;

  static const List<String> _allowedExtensions = [
    'pdf',
    'jpg',
    'jpeg',
    'png',
    'tif',
    'tiff',
  ];

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: _allowedExtensions,
      withData: false,
    );
    if (result == null || result.files.isEmpty) return;
    final file = result.files.single;
    if (file.name.isEmpty) return;
    setState(() => _pickedFile = file);
  }

  void _handleUpload() {
    if (_pickedFile == null) return;
    widget.onUpload?.call(_pickedFile!);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Upload will be sent when backend is connected.',
        ),
      ),
    );
  }

  void _handleReplace() {
    if (_pickedFile == null) {
      _pickFile();
      return;
    }
    widget.onReplace?.call(_pickedFile!);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Replace will be sent when backend is connected.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activity = widget.activity;

    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.map_outlined, size: 22, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                'Upload Basemap',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (activity.basemapUploaded) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Basemap File',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'basemap_${activity.id}.pdf',
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
            ),
            const SizedBox(height: 16),
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.visibility_outlined,
                        size: 40,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Basemap Preview',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () async {
                await _pickFile();
                if (mounted && _pickedFile != null) _handleReplace();
              },
              icon: const Icon(Icons.upload_outlined, size: 20),
              label: const Text('Replace Basemap'),
            ),
          ] else ...[
            Text(
              'Select Basemap File',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: _pickFile,
              icon: const Icon(Icons.folder_open_outlined, size: 20),
              label: Text(_pickedFile == null ? 'Choose file' : _pickedFile!.name),
            ),
            if (_pickedFile != null) ...[
              const SizedBox(height: 8),
              Text(
                _pickedFile!.name,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ],
            const SizedBox(height: 8),
            Text(
              'Supported formats: PDF, JPG, PNG, GeoTIFF',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _pickedFile != null ? _handleUpload : null,
              icon: const Icon(Icons.upload_outlined, size: 20),
              label: const Text('Upload Basemap'),
            ),
          ],
        ],
      ),
    );
  }
}
