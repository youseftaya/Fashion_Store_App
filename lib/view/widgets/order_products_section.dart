import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/order_model.dart';
import 'order_section_card.dart';

class OrderProductsSection extends StatelessWidget {
  final OrderModel order;

  const OrderProductsSection({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return OrderSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ORDERED ITEMS',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.7,
            ),
          ),
          const SizedBox(height: 16),
          ...order.items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      item.product.imageUrl,
                      width: 72,
                      height: 82,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 72,
                          height: 82,
                          color: AppColors.lightGrey,
                          child: const Icon(
                            Icons.image_not_supported_outlined,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.product.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.productName,
                        ),
                        const SizedBox(height: 7),
                        Text(
                          'Size: ${item.size}',
                          style: const TextStyle(
                            color: AppColors.secondary,
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Color: ${item.color}',
                          style: const TextStyle(
                            color: AppColors.secondary,
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Quantity: ${item.quantity}',
                          style: const TextStyle(fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '\$${item.totalPrice.toStringAsFixed(2)}',
                    style: AppTextStyles.price.copyWith(fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}