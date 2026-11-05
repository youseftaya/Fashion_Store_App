import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class OrderSectionCard extends StatelessWidget {
  final Widget child;

  const OrderSectionCard({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lightGrey),
      ),
      child: child,
    );
  }
}