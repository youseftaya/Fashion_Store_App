import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class CheckoutTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType keyboardType;
  final int maxLines;

  const CheckoutTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
  });

  String? _validator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter $label';
    }

    if (label == 'Email Address' &&
        !RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }

    if (label == 'Phone Number' &&
        value.trim().replaceAll(RegExp(r'\D'), '').length < 10) {
      return 'Please enter a valid phone number';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: _validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          icon,
          color: AppColors.secondary,
        ),
        filled: true,
        fillColor: AppColors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: AppColors.lightGrey,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}