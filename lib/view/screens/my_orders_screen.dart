import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../providers/order_provider.dart';
import '../../data/models/order_model.dart';
import '../widgets/orders_filter_list.dart';
import '../widgets/orders_empty_state.dart';
import '../widgets/order_card.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  String _selectedStatus = 'All';

  Future<void> _confirmCancelOrder(
    OrderProvider provider,
    OrderModel order,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Cancel Order?'),
        content: const Text(
          'Are you sure you want to cancel this order? '
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Keep Order'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text(
              'Cancel Order',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    try {
      final success = await provider.cancelOrder(order.id);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? 'Order cancelled successfully.'
                : 'This order cannot be cancelled.',
          ),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to cancel order. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

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
          'MY ORDERS',
          style: AppTextStyles.sectionTitle.copyWith(
            fontSize: 15,
            letterSpacing: 1.5,
          ),
        ),
      ),
      body: Consumer<OrderProvider>(
        builder: (context, orderProvider, child) {
          if (orderProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            );
          }

          final allOrders = orderProvider.orders;

          if (allOrders.isEmpty) {
            return const OrdersEmptyState(
              title: 'NO ORDERS YET',
              message: 'Your orders will appear here.',
            );
          }

          final filteredOrders =
              orderProvider.getOrdersByStatus(_selectedStatus);

          return Column(
            children: [
              OrdersFilterList(
                selectedStatus: _selectedStatus,
                provider: orderProvider,
                onStatusSelected: (status) {
                  setState(() {
                    _selectedStatus = status;
                  });
                },
              ),
              Expanded(
                child: filteredOrders.isEmpty
                    ? OrdersEmptyState(
                        title: 'NO ${_selectedStatus.toUpperCase()} ORDERS',
                        message: 'There are no orders in this category.',
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(20),
                        itemCount: filteredOrders.length,
                        separatorBuilder: (_, _) =>
                            const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final order = filteredOrders[index];

                          return OrderCard(
                            order: order,
                            onCancel: orderProvider.canCancelOrder(order)
                                ? () => _confirmCancelOrder(
                                      orderProvider,
                                      order,
                                    )
                                : null,
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}