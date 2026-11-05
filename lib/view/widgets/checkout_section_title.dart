import 'package:flutter/material.dart';

import '../../../core/theme/app_text_styles.dart';

class CheckoutSectionTitle extends StatelessWidget {
  final String title;

  const CheckoutSectionTitle({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTextStyles.sectionTitle.copyWith(
        fontSize: 14,
        letterSpacing: 1.2,
      ),
    );
  }
}