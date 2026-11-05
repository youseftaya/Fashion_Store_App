import 'package:flutter/material.dart';
import 'circle_icon_button.dart';

class ProductQuantitySelector extends StatelessWidget {
  final int quantity;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;

  const ProductQuantitySelector({
    super.key,
    required this.quantity,
    required this.onDecrease,
    required this.onIncrease,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'QUANTITY',
          style: TextStyle(
            fontSize: 12,
            letterSpacing: 1.4,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            CircleIconButton(
              icon: Icons.remove,
              onTap: onDecrease,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Text(
                '$quantity',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            CircleIconButton(
              icon: Icons.add,
              onTap: onIncrease,
            ),
          ],
        ),
      ],
    );
  }
}