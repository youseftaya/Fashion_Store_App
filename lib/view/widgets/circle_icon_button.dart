import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color iconColor;

  const CircleIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.iconColor = AppColors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.lightGrey,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 42,
          height: 42,
          child: Icon(icon, color: iconColor, size: 20),
        ),
      ),
    );
  }
}