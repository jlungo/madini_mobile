import 'package:flutter/material.dart';

import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_input.dart';
import '../../domain/entities/mapping_activity_entity.dart';

/// Reusable form for create/edit mapping activity. Caller handles submit (create/update).
class MappingActivityForm extends StatefulWidget {
  const MappingActivityForm({
    super.key,
    this.initial,
    required this.onSave,
    this.isLoading = false,
    this.submitLabel = 'Save',
    this.cancelLabel = 'Cancel',
  });

  final MappingActivityEntity? initial;
  final void Function(MappingActivityEntity entity) onSave;
  final bool isLoading;
  final String submitLabel;
  final String cancelLabel;

  @override
  State<MappingActivityForm> createState() => _MappingActivityFormState();
}

class _MappingActivityFormState extends State<MappingActivityForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _locationController;
  late final TextEditingController _leadScientistController;
  late final TextEditingController _createdDateController;
  String _activityType = 'Internal';
  String _surveyType = 'Geological';

  static const List<String> _activityTypes = ['Internal', 'Consultancy'];
  static const List<String> _surveyTypes = [
    'Geological',
    'Geochemical',
    'Geophysical',
    'Geohazard',
  ];

  @override
  void initState() {
    super.initState();
    final e = widget.initial;
    _nameController = TextEditingController(text: e?.activityName ?? '');
    _locationController = TextEditingController(text: e?.location ?? '');
    _leadScientistController = TextEditingController(text: e?.leadScientist ?? '');
    _createdDateController = TextEditingController(
      text: e?.createdDate ?? _today(),
    );
    _activityType = e?.activityType ?? 'Internal';
    _surveyType = e?.surveyType ?? 'Geological';
  }

  static String _today() {
    final d = DateTime.now();
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _leadScientistController.dispose();
    _createdDateController.dispose();
    super.dispose();
  }

  MappingActivityEntity _buildEntity() {
    final e = widget.initial;
    return MappingActivityEntity(
      id: e?.id ?? '',
      activityName: _nameController.text.trim(),
      activityType: _activityType,
      surveyType: _surveyType,
      location: _locationController.text.trim(),
      status: e?.status ?? 'Planned',
      createdDate: _createdDateController.text.trim(),
      completedDate: e?.completedDate,
      leadScientist: _leadScientistController.text.trim(),
      samplesCollected: e?.samplesCollected ?? false,
      basemapUploaded: e?.basemapUploaded ?? false,
      reportsGenerated: e?.reportsGenerated ?? false,
      source: e?.source,
      approvedByEoffice: e?.approvedByEoffice ?? false,
      editorialStatus: e?.editorialStatus,
      finalUploadDate: e?.finalUploadDate,
      deskworkCompleted: e?.deskworkCompleted ?? false,
      deskworkNotes: e?.deskworkNotes,
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    widget.onSave(_buildEntity());
  }

  Future<void> _pickDate() async {
    final initial = DateTime.tryParse(_createdDateController.text);
    final picked = await showDatePicker(
      context: context,
      initialDate: initial ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      _createdDateController.text =
          '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          AppInput(
            controller: _nameController,
            label: 'Activity Name *',
            hintText: 'Enter activity name',
            enabled: !widget.isLoading,
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Required' : null,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _DropdownField(
                  label: 'Activity Type *',
                  value: _activityType,
                  items: _activityTypes,
                  enabled: !widget.isLoading,
                  onChanged: (v) => setState(() => _activityType = v!),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _DropdownField(
                  label: 'Survey Type *',
                  value: _surveyType,
                  items: _surveyTypes,
                  enabled: !widget.isLoading,
                  onChanged: (v) => setState(() => _surveyType = v!),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          AppInput(
            controller: _locationController,
            label: 'Location *',
            hintText: 'Enter location',
            enabled: !widget.isLoading,
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Required' : null,
          ),
          const SizedBox(height: 16),
          AppInput(
            controller: _leadScientistController,
            label: 'Lead Scientist *',
            hintText: 'Enter lead scientist name',
            enabled: !widget.isLoading,
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Required' : null,
          ),
          const SizedBox(height: 16),
          _DateField(
            controller: _createdDateController,
            enabled: !widget.isLoading,
            onTap: _pickDate,
          ),
          const SizedBox(height: 24),
          AppButton(
            onPressed: widget.isLoading ? null : _submit,
            fullWidth: true,
            child: Text(
              widget.submitLabel,
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.onPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 8),
          AppButton(
            onPressed: widget.isLoading ? null : () => Navigator.of(context).pop(),
            fullWidth: true,
            variant: AppButtonVariant.secondary,
            child: Text(widget.cancelLabel, style: theme.textTheme.labelLarge),
          ),
        ],
      ),
    );
  }
}

class _DropdownField extends StatelessWidget {
  const _DropdownField({
    required this.label,
    required this.value,
    required this.items,
    required this.enabled,
    required this.onChanged,
  });

  final String label;
  final String value;
  final List<String> items;
  final bool enabled;
  final void Function(String?) onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 4),
        DropdownButtonFormField<String>(
          initialValue: value,
          items: items
              .map((s) => DropdownMenuItem(value: s, child: Text(s)))
              .toList(),
          onChanged: enabled ? onChanged : null,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
        ),
      ],
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({
    required this.controller,
    required this.enabled,
    required this.onTap,
  });

  final TextEditingController controller;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Created Date',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          readOnly: true,
          enabled: enabled,
          onTap: enabled ? onTap : null,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'YYYY-MM-DD',
            suffixIcon: Icon(Icons.calendar_today_outlined),
          ),
        ),
      ],
    );
  }
}
