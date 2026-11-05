import 'package:flutter/material.dart';

import '../../data/models/order_model.dart';
import 'order_section_card.dart';
import 'order_info_row.dart';

class OrderInfoSection extends StatelessWidget {
  final OrderModel order;

  const OrderInfoSection({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    final date = order.createdAt;

    return OrderSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ORDER INFORMATION',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.7,
            ),
          ),
          const SizedBox(height: 16),
          OrderInfoRow(
            label: 'Order ID',
            value: '#${order.id}',
          ),
          const SizedBox(height: 12),
          OrderInfoRow(
            label: 'Order Date',
            value: '${date.day.toString().padLeft(2, '0')}/'
                '${date.month.toString().padLeft(2, '0')}/'
                '${date.year}',
          ),
          const SizedBox(height: 12),
          OrderInfoRow(
            label: 'Order Status',
            value: order.status.toUpperCase(),
          ),
        ],
      ),
    );
  }
}