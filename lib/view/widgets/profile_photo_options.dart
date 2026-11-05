import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

void showProfilePhotoOptions({
  required BuildContext context,
  required bool hasPhoto,
  required VoidCallback onChoose,
  required VoidCallback onRemove,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: AppColors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(22),
      ),
    ),
    builder: (sheetContext) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.lightGrey,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'PROFILE PHOTO',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.3,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(
                  Icons.photo_library_outlined,
                  color: AppColors.primary,
                ),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(sheetContext);
                  onChoose();
                },
              ),
              if (hasPhoto)
                ListTile(
                  leading: const Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                  ),
                  title: const Text('Remove Photo'),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    onRemove();
                  },
                ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      );
    },
  );
}