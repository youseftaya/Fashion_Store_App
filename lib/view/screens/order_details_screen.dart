import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/order_model.dart';

import '../widgets/order_info_section.dart';
import '../widgets/order_tracking_section.dart';
import '../widgets/order_products_section.dart';
import '../widgets/order_delivery_section.dart';
import '../widgets/order_payment_section.dart';
import '../widgets/order_summary_section.dart';

class OrderDetailsScreen extends StatelessWidget {
  final OrderModel order;

  const OrderDetailsScreen({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.primary,
            size: 20,
          ),
        ),
        title: Text(
          'ORDER DETAILS',
          style: AppTextStyles.sectionTitle.copyWith(
            fontSize: 15,
            letterSpacing: 1.5,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          OrderInfoSection(order: order),
          const SizedBox(height: 20),

          OrderTrackingSection(status: order.status),
          const SizedBox(height: 20),

          OrderProductsSection(order: order),
          const SizedBox(height: 20),

          OrderDeliverySection(order: order),
          const SizedBox(height: 20),

          OrderPaymentSection(order: order),
          const SizedBox(height: 20),

          OrderSummarySection(order: order),
          const SizedBox(height: 25),
        ],
      ),
    );
  }
}