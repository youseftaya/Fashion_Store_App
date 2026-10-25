import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class HomeHeader extends StatelessWidget {
  final VoidCallback onProfileTap;

  const HomeHeader({
    super.key,
    required this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'MODE',
              style: TextStyle(
                fontSize: 29,
                fontWeight: FontWeight.w900,
                letterSpacing: 4,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              'LESS, BUT BETTER.',
              style: TextStyle(
                fontSize: 9,
                letterSpacing: 2.2,
                color: AppColors.secondary.withValues(alpha: 0.9),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        Material(
          color: AppColors.lightGrey,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onProfileTap,
            child: const SizedBox(
              width: 46,
              height: 46,
              child: Icon(
                Icons.person_outline,
                color: AppColors.primary,
                size: 24,
              ),
            ),
          ),
        ),
      ],
    );
  }
}