import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/order_model.dart';
import 'order_section_card.dart';

class OrderPaymentSection extends StatelessWidget {
  final OrderModel order;

  const OrderPaymentSection({
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
            'PAYMENT METHOD',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.7,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(
                Icons.payments_outlined,
                color: AppColors.primary,
                size: 25,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  order.paymentMethod,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 20,
              ),
            ],
          ),
        ],
      ),
    );
  }
}