import 'package:flutter/material.dart';

import '../../core/theme/app_text_styles.dart';

class ProfileSectionTitle extends StatelessWidget {
  final String title;

  const ProfileSectionTitle({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: AppTextStyles.sectionTitle.copyWith(
          fontSize: 13,
          letterSpacing: 1.3,
        ),
      ),
    );
  }
}