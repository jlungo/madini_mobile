import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../../../shared/widgets/app_card.dart';
import '../../domain/entities/mapping_activity_entity.dart';

/// Step content: Site Visit & Data Collection – GPS, photos, field notes,
/// survey-type-specific fields, "Were samples collected?" Yes/No, Submit Field Data.
class StepContentSiteVisit extends StatefulWidget {
  const StepContentSiteVisit({
    super.key,
    required this.activity,
    this.onSubmitFieldData,
    this.onSamplesCollectedChanged,
  });

  final MappingActivityEntity activity;
  /// Called when user taps Submit Field Data (for future API integration).
  final void Function({
    String? gpsCoordinates,
    List<PlatformFile>? photos,
    String? fieldNotes,
    Map<String, String>? surveyData,
    bool? samplesCollected,
  })? onSubmitFieldData;
  /// Called when user changes "Were samples collected?" (for future API integration).
  final void Function(bool yes)? onSamplesCollectedChanged;

  @override
  State<StepContentSiteVisit> createState() => _StepContentSiteVisitState();
}

class _StepContentSiteVisitState extends State<StepContentSiteVisit> {
  final _gpsController = TextEditingController();
  final _fieldNotesController = TextEditingController();
  final _surveyDataControllers = <String, TextEditingController>{};
  List<PlatformFile> _pickedPhotos = [];
  bool? _samplesCollected; // true = yes, false = no, null = not selected

  static const List<String> _imageExtensions = ['jpg', 'jpeg', 'png', 'heic', 'webp'];

  @override
  void dispose() {
    _gpsController.dispose();
    _fieldNotesController.dispose();
    for (final c in _surveyDataControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  List<String> get _surveyFieldKeys {
    switch (widget.activity.surveyType) {
      case 'Geological':
        return ['Rock Type', 'Structural Features', 'Mineralization'];
      case 'Geochemical':
        return ['Sample ID', 'Sample Depth', 'Sample Type (Soil/Rock/Water)'];
      case 'Geophysical':
        return ['Reading Type', 'Measurement Value', 'Instrument Used'];
      case 'Geohazard':
        return ['Hazard Type', 'Risk Level', 'Mitigation Measures'];
      default:
        return [];
    }
  }

  TextEditingController _surveyController(String label) {
    return _surveyDataControllers.putIfAbsent(
      label,
      () => TextEditingController(),
    );
  }

  Future<void> _pickPhotos() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: _imageExtensions,
      withData: false,
      allowMultiple: true,
    );
    if (result == null || result.files.isEmpty) return;
    setState(() {
      _pickedPhotos = result.files.where((f) => f.name.isNotEmpty).toList();
    });
  }

  void _handleSubmitFieldData() {
    final surveyData = <String, String>{};
    for (final key in _surveyFieldKeys) {
      final value = _surveyController(key).text.trim();
      if (value.isNotEmpty) surveyData[key] = value;
    }
    widget.onSubmitFieldData?.call(
      gpsCoordinates: _gpsController.text.trim().isEmpty ? null : _gpsController.text.trim(),
      photos: _pickedPhotos.isEmpty ? null : _pickedPhotos,
      fieldNotes: _fieldNotesController.text.trim().isEmpty ? null : _fieldNotesController.text.trim(),
      surveyData: surveyData.isEmpty ? null : surveyData,
      samplesCollected: _samplesCollected,
    );
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Field data will be sent when backend is connected.'),
      ),
    );
  }

  String get _surveyHint {
    switch (widget.activity.surveyType) {
      case 'Geological':
        return 'Record rock types, structures, mineralization, etc.';
      case 'Geochemical':
        return 'Record sample locations, soil/rock chemistry, etc.';
      case 'Geophysical':
        return 'Record magnetic/gravity readings, seismic data, etc.';
      case 'Geohazard':
        return 'Record hazard observations, risk assessments, etc.';
      default:
        return 'Survey-specific data for ${widget.activity.surveyType}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activity = widget.activity;
    final showSamplesDecision = activity.status == 'On-site Data Collection' ||
        activity.status == 'Deskwork & Base Map' ||
        activity.status == 'Field Data Collection';

    return SingleChildScrollView(
      child: AppCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.camera_alt_outlined, size: 22, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Field Data Collection',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _gpsController,
              decoration: const InputDecoration(
                labelText: 'GPS Coordinates',
                hintText: 'e.g. -6.7924, 39.2083',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.streetAddress,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _pickPhotos,
              icon: const Icon(Icons.photo_library_outlined, size: 20),
              label: Text(
                _pickedPhotos.isEmpty
                    ? 'Attach Photos'
                    : '${_pickedPhotos.length} photo(s) selected',
              ),
            ),
            if (_pickedPhotos.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  'Upload field photos and observations',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ),
            const SizedBox(height: 12),
            TextField(
              controller: _fieldNotesController,
              decoration: const InputDecoration(
                labelText: 'Field Notes',
                hintText: 'Enter detailed field observations...',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              maxLines: 5,
              textInputAction: TextInputAction.newline,
            ),
            const SizedBox(height: 16),
            Divider(color: theme.colorScheme.outlineVariant),
            const SizedBox(height: 12),
            Text(
              'Survey-Specific Data',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _surveyHint,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 8),
            ..._surveyFieldKeys.map(
              (label) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: TextField(
                  controller: _surveyController(label),
                  decoration: InputDecoration(
                    labelText: label,
                    border: const OutlineInputBorder(),
                  ),
                  textInputAction: TextInputAction.next,
                ),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _handleSubmitFieldData,
              icon: const Icon(Icons.save_outlined, size: 20),
              label: const Text('Submit Field Data'),
            ),
            if (showSamplesDecision) ...[
              const SizedBox(height: 20),
              Divider(color: theme.colorScheme.outlineVariant),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: theme.colorScheme.primary.withValues(alpha: 0.5),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 18,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Were samples collected?',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    RadioGroup<bool>(
                      groupValue: _samplesCollected,
                      onChanged: (bool? value) {
                        if (value == null) return;
                        setState(() => _samplesCollected = value);
                        widget.onSamplesCollectedChanged?.call(value);
                      },
                      child: Column(
                        children: [
                          ListTile(
                            title: const Text('Yes'),
                            leading: Radio<bool>(value: true),
                            onTap: () {
                              setState(() => _samplesCollected = true);
                              widget.onSamplesCollectedChanged?.call(true);
                            },
                          ),
                          ListTile(
                            title: const Text('No'),
                            leading: Radio<bool>(value: false),
                            onTap: () {
                              setState(() => _samplesCollected = false);
                              widget.onSamplesCollectedChanged?.call(false);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
