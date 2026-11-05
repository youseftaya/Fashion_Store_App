import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class OrderInfoRow extends StatelessWidget {
  final String label;
  final String value;

  const OrderInfoRow({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 95,
          child: Text(
            label,
            style: const TextStyle(
              color: AppColors.secondary,
              fontSize: 11,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value.isEmpty ? 'Not provided' : value,
            textAlign: TextAlign.end,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}