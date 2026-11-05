import 'package:flutter/material.dart';

import '../../core/theme/app_text_styles.dart';
import '../../data/models/order_model.dart';
import 'order_section_card.dart';
import 'order_info_row.dart';

class OrderSummarySection extends StatelessWidget {
  final OrderModel order;

  const OrderSummarySection({
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
            'ORDER SUMMARY',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.7,
            ),
          ),
          const SizedBox(height: 16),
          OrderInfoRow(
            label: 'Items',
            value: '${order.items.length}',
          ),
          const SizedBox(height: 12),
          OrderInfoRow(
            label: 'Payment',
            value: order.paymentMethod,
          ),
          const Divider(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'TOTAL AMOUNT',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                '\$${order.totalPrice.toStringAsFixed(2)}',
                style: AppTextStyles.price.copyWith(fontSize: 20),
              ),
            ],
          ),
        ],
      ),
    );
  }
}