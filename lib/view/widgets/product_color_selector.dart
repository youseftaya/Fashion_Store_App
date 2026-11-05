import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class ProductColorSelector extends StatelessWidget {
  final List<Color> colors;
  final Color selectedColor;
  final ValueChanged<Color> onColorSelected;

  const ProductColorSelector({
    super.key,
    required this.colors,
    required this.selectedColor,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'SELECT COLOR',
          style: TextStyle(
            fontSize: 12,
            letterSpacing: 1.4,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 14),
        Row(
          children: colors.map((color) {
            final selected = selectedColor == color;

            return GestureDetector(
              onTap: () => onColorSelected(color),
              child: Container(
                margin: const EdgeInsets.only(right: 15),
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selected
                        ? AppColors.primary
                        : AppColors.lightGrey,
                    width: selected ? 3 : 1,
                  ),
                ),
                child: selected
                    ? Icon(
                        Icons.check,
                        size: 18,
                        color: color == Colors.white
                            ? Colors.black
                            : Colors.white,
                      )
                    : null,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}