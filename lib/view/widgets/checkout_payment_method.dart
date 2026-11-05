import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class CheckoutPaymentMethod extends StatelessWidget {
  const CheckoutPaymentMethod({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primary,
        ),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.money,
            color: AppColors.primary,
            size: 28,
          ),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cash on Delivery',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Pay when your order arrives.',
                  style: TextStyle(
                    color: AppColors.secondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.check_circle,
            color: AppColors.primary,
          ),
        ],
      ),
    );
  }
}