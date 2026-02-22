import 'package:flutter/material.dart';

import '../../../../shared/widgets/app_card.dart';
import '../../domain/entities/mapping_activity_entity.dart';

/// Payload for sending specimens to archive (for controller/API).
class PreserveSpecimensPayload {
  const PreserveSpecimensPayload({
    required this.specimenCount,
    required this.specimenType,
    required this.destination,
    this.notes,
  });

  final int specimenCount;
  final String specimenType;
  final String destination;
  final String? notes;
}

/// Step content: Preserve Specimens – specimen count, type, destination, notes,
/// Send to Archive action. Callback [onSendToArchive] for controller/API integration.
class StepContentPreserve extends StatefulWidget {
  const StepContentPreserve({
    super.key,
    required this.activity,
    this.onSendToArchive,
    this.isSubmitting = false,
  });

  final MappingActivityEntity activity;
  /// Called when user taps Send to Archive (controller can call API here).
  final void Function(PreserveSpecimensPayload payload)? onSendToArchive;
  /// When true, disable form and show loading (e.g. from controller).
  final bool isSubmitting;

  @override
  State<StepContentPreserve> createState() => _StepContentPreserveState();
}

class _StepContentPreserveState extends State<StepContentPreserve> {
  final _countController = TextEditingController();
  final _typeController = TextEditingController();
  final _destinationController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _countController.dispose();
    _typeController.dispose();
    _destinationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _handleSendToArchive() {
    final countStr = _countController.text.trim();
    final type = _typeController.text.trim();
    final destination = _destinationController.text.trim();
    if (countStr.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter number of specimens')),
      );
      return;
    }
    final count = int.tryParse(countStr);
    if (count == null || count < 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid specimen count (≥ 1)')),
      );
      return;
    }
    if (type.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter specimen type')),
      );
      return;
    }
    if (destination.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter destination')),
      );
      return;
    }
    widget.onSendToArchive?.call(PreserveSpecimensPayload(
      specimenCount: count,
      specimenType: type,
      destination: destination,
      notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final submitting = widget.isSubmitting;

    return SingleChildScrollView(
      child: AppCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.account_balance_outlined, size: 22, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Preserve Physical Specimens',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _countController,
              decoration: const InputDecoration(
                labelText: 'Number of Specimens',
                hintText: 'Enter number of specimens',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              enabled: !submitting,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _typeController,
              decoration: const InputDecoration(
                labelText: 'Specimen Type',
                hintText: 'e.g. Rock samples, Fossils',
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.next,
              enabled: !submitting,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _destinationController,
              decoration: const InputDecoration(
                labelText: 'Destination',
                hintText: 'Museum / Storage Archive',
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.next,
              enabled: !submitting,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Preservation Notes',
                hintText: 'Special handling or storage requirements...',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              maxLines: 3,
              textInputAction: TextInputAction.newline,
              enabled: !submitting,
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: submitting ? null : _handleSendToArchive,
              icon: submitting
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: theme.colorScheme.onPrimary,
                      ),
                    )
                  : const Icon(Icons.account_balance_outlined, size: 20),
              label: Text(submitting ? 'Sending…' : 'Send to Archive'),
            ),
          ],
        ),
      ),
    );
  }
}
