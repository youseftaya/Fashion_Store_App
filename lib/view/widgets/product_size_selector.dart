import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class ProductSizeSelector extends StatelessWidget {
  final List<String> sizes;
  final String? selectedSize;
  final ValueChanged<String> onSizeSelected;

  const ProductSizeSelector({
    super.key,
    required this.sizes,
    required this.selectedSize,
    required this.onSizeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'SELECT SIZE',
          style: TextStyle(
            fontSize: 12,
            letterSpacing: 1.4,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 12,
          children: sizes.map((size) {
            final selected = selectedSize == size;

            return GestureDetector(
              onTap: () => onSizeSelected(size),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 48,
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected ? AppColors.primary : AppColors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: selected
                        ? AppColors.primary
                        : AppColors.lightGrey,
                  ),
                ),
                child: Text(
                  size,
                  style: TextStyle(
                    color: selected ? AppColors.white : AppColors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}