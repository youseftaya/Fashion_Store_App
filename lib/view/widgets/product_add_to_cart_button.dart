import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class ProductAddToCartButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ProductAddToCartButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.shopping_bag_outlined),
        label: const Text(
          'ADD TO CART',
          style: TextStyle(
            fontSize: 13,
            letterSpacing: 1.5,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}