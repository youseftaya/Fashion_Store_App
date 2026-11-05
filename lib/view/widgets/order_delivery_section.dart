import 'package:flutter/material.dart';

import '../../data/models/order_model.dart';
import 'order_section_card.dart';
import 'order_info_row.dart';

class OrderDeliverySection extends StatelessWidget {
  final OrderModel order;

  const OrderDeliverySection({
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
            'DELIVERY INFORMATION',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.7,
            ),
          ),
          const SizedBox(height: 16),
          OrderInfoRow(
            label: 'Customer',
            value: order.customerName,
          ),
          const SizedBox(height: 12),
          OrderInfoRow(
            label: 'Phone',
            value: order.phone,
          ),
          const SizedBox(height: 12),
          OrderInfoRow(
            label: 'Email',
            value: order.email,
          ),
          const SizedBox(height: 12),
          OrderInfoRow(
            label: 'Address',
            value: order.address,
          ),
        ],
      ),
    );
  }
}