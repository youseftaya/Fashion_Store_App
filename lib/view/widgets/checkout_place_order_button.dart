import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class CheckoutPlaceOrderButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;

  const CheckoutPlaceOrderButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          disabledBackgroundColor: AppColors.secondary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Text(
                'PLACE ORDER',
                style: TextStyle(
                  fontSize: 13,
                  letterSpacing: 1.3,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}