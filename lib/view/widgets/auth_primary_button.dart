import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class AuthPrimaryButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;
  final String title;

  const AuthPrimaryButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
    this.title = 'SIGN IN',
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
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
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
      ),
    );
  }
}