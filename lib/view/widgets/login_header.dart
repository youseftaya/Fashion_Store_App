import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            'MODE',
            style: AppTextStyles.sectionTitle.copyWith(
              fontSize: 34,
              letterSpacing: 6,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'WELCOME BACK',
            style: TextStyle(
              color: AppColors.secondary,
              fontSize: 12,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Sign in to continue shopping.',
            style: TextStyle(
              color: AppColors.secondary,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}