import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class AuthBottomPrompt extends StatelessWidget {
  final VoidCallback onPressed;

  const AuthBottomPrompt({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Expanded(child: Divider()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Text(
                'NEW TO MODE?',
                style: TextStyle(
                  color: AppColors.secondary,
                  fontSize: 10,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            const Expanded(child: Divider()),
          ],
        ),
        const SizedBox(height: 18),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: OutlinedButton(
            onPressed: onPressed,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'CREATE ACCOUNT',
              style: TextStyle(
                fontSize: 12,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Center(
          child: Text(
            'STYLE YOUR WAY',
            style: TextStyle(
              color: AppColors.secondary,
              fontSize: 10,
              letterSpacing: 2,
            ),
          ),
        ),
      ],
    );
  }
}