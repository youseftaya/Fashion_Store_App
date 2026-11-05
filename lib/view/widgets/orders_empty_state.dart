import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class OrdersEmptyState extends StatelessWidget {
  final String title;
  final String message;

  const OrdersEmptyState({
    super.key,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.receipt_long_outlined,
              size: 68,
              color: AppColors.secondary,
            ),
            const SizedBox(height: 18),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.sectionTitle.copyWith(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.secondary,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
