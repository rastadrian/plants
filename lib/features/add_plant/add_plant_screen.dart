import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/plant_provider.dart';
import 'widgets/interval_picker.dart';
import 'widgets/photo_picker_widget.dart';

class AddPlantScreen extends ConsumerStatefulWidget {
  const AddPlantScreen({super.key});

  @override
  ConsumerState<AddPlantScreen> createState() => _AddPlantScreenState();
}

class _AddPlantScreenState extends ConsumerState<AddPlantScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  File? _photo;
  int _weeks = 1;
  bool _saving = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      await ref.read(plantsProvider.notifier).addPlant(
            name: _nameController.text.trim(),
            wateringIntervalDays: _weeks * 7,
            photo: _photo,
          );
      if (mounted) Navigator.of(context).pop();
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Plant'),
        actions: [
          TextButton(
            onPressed: _saving ? null : _save,
            child: _saving
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.textIcons,
                    ),
                  )
                : const Text('Save', style: TextStyle(color: AppColors.textIcons)),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            PhotoPickerWidget(
              photo: _photo,
              onPhotoSelected: (f) => setState(() => _photo = f),
            ),
            const SizedBox(height: 28),
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
            const SizedBox(height: 24),
            IntervalPicker(
              value: _weeks,
              onChanged: (w) => setState(() => _weeks = w),
            ),
          ],
        ),
      ),
    );
  }
}
