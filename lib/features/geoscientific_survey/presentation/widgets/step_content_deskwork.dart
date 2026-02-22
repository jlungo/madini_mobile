import 'package:flutter/material.dart';

import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../domain/entities/mapping_activity_entity.dart';

/// Step content: Deskwork – literature review, satellite data, spatial overlay.
/// Checklist + optional notes; "Mark complete" persists via [onSave].
/// Auth is enforced by the caller (controller/API layer).
class StepContentDeskwork extends StatefulWidget {
  const StepContentDeskwork({
    super.key,
    required this.activity,
    required this.onSave,
    this.isSaving = false,
  });

  final MappingActivityEntity activity;
  final void Function({required bool completed, String? notes}) onSave;
  final bool isSaving;

  @override
  State<StepContentDeskwork> createState() => _StepContentDeskworkState();
}

class _StepContentDeskworkState extends State<StepContentDeskwork> {
  late bool _literatureDone;
  late bool _satelliteDone;
  late bool _spatialOverlayDone;
  late TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    final completed = widget.activity.deskworkCompleted;
    _literatureDone = completed;
    _satelliteDone = completed;
    _spatialOverlayDone = completed;
    _notesController = TextEditingController(text: widget.activity.deskworkNotes ?? '');
  }

  @override
  void didUpdateWidget(StepContentDeskwork oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.activity.id != widget.activity.id) {
      _literatureDone = false;
      _satelliteDone = false;
      _spatialOverlayDone = false;
      _notesController.text = widget.activity.deskworkNotes ?? '';
    } else if (widget.activity.deskworkCompleted) {
      _literatureDone = true;
      _satelliteDone = true;
      _spatialOverlayDone = true;
      if (widget.activity.deskworkNotes != null && _notesController.text != widget.activity.deskworkNotes) {
        _notesController.text = widget.activity.deskworkNotes!;
      }
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  bool get _allChecked => _literatureDone && _satelliteDone && _spatialOverlayDone;

  void _submitCompleted() {
    widget.onSave(
      completed: true,
      notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
    );
  }

  void _submitInProgress() {
    widget.onSave(
      completed: _allChecked,
      notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Deskwork',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Literature review, satellite data interrogation, and spatial overlay before basemap.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 20),
          CheckboxListTile(
            value: _literatureDone,
            onChanged: widget.isSaving ? null : (v) => setState(() => _literatureDone = v ?? false),
            title: const Text('Literature review completed'),
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
          ),
          CheckboxListTile(
            value: _satelliteDone,
            onChanged: widget.isSaving ? null : (v) => setState(() => _satelliteDone = v ?? false),
            title: const Text('Satellite data interrogated'),
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
          ),
          CheckboxListTile(
            value: _spatialOverlayDone,
            onChanged: widget.isSaving ? null : (v) => setState(() => _spatialOverlayDone = v ?? false),
            title: const Text('Spatial data overlay completed'),
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _notesController,
            enabled: !widget.isSaving,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Notes',
              hintText: 'Optional notes on deskwork...',
              border: OutlineInputBorder(),
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              AppButton(
                onPressed: widget.isSaving ? null : _submitInProgress,
                child: Text(widget.activity.deskworkCompleted ? 'Update' : 'Save progress'),
              ),
              if (_allChecked) ...[
                const SizedBox(width: 12),
                AppButton(
                  onPressed: widget.isSaving || widget.activity.deskworkCompleted
                      ? null
                      : _submitCompleted,
                  child: const Text('Mark complete'),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
