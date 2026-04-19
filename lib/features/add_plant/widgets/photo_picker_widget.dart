import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/theme/app_colors.dart';

class PhotoPickerWidget extends StatelessWidget {
  const PhotoPickerWidget({
    super.key,
    required this.photo,
    required this.onPhotoSelected,
  });

  final File? photo;
  final ValueChanged<File> onPhotoSelected;

  Future<void> _pick(BuildContext context, ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: source,
      imageQuality: 80,
      maxWidth: 800,
    );
    if (picked != null) {
      onPhotoSelected(File(picked.path));
    }
  }

  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take photo'),
              onTap: () {
                Navigator.pop(context);
                _pick(context, ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from gallery'),
              onTap: () {
                Navigator.pop(context);
                _pick(context, ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showOptions(context),
      child: Center(
        child: Stack(
          children: [
            CircleAvatar(
              radius: 52,
              backgroundColor: AppColors.lightPrimary,
              backgroundImage: photo != null ? FileImage(photo!) : null,
              child: photo == null
                  ? const Icon(
                      Icons.local_florist,
                      size: 40,
                      color: AppColors.darkPrimary,
                    )
                  : null,
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.camera_alt, size: 16, color: AppColors.textIcons),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
