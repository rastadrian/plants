import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/plant.dart';
import '../../../providers/plant_provider.dart';
import '../../add_plant/widgets/interval_picker.dart';
import '../../add_plant/widgets/photo_picker_widget.dart';

class EditPlantForm extends ConsumerStatefulWidget {
  const EditPlantForm({super.key, required this.plant, required this.onDone});

  final Plant plant;
  final VoidCallback onDone;

  @override
  ConsumerState<EditPlantForm> createState() => _EditPlantFormState();
}

class _EditPlantFormState extends ConsumerState<EditPlantForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  File? _newPhoto;
  late int _weeks;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.plant.name);
    _weeks = (widget.plant.wateringIntervalDays / 7).round().clamp(1, 12);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      await ref.read(plantsProvider.notifier).updatePlant(
            id: widget.plant.id,
            name: _nameController.text.trim(),
            wateringIntervalDays: _weeks * 7,
            newPhoto: _newPhoto,
          );
      widget.onDone();
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PhotoPickerWidget(
            photo: _newPhoto ?? (widget.plant.photoPath != null ? File(widget.plant.photoPath!) : null),
            onPhotoSelected: (f) => setState(() => _newPhoto = f),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _nameController,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              labelText: 'Plant name',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.local_florist),
            ),
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Please enter a name' : null,
          ),
          const SizedBox(height: 16),
          IntervalPicker(
            value: _weeks,
            onChanged: (w) => setState(() => _weeks = w),
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: _saving ? null : _save,
            style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
            child: _saving
                ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: AppColors.textIcons),
                  )
                : const Text('Save changes'),
          ),
        ],
      ),
    );
  }
}
