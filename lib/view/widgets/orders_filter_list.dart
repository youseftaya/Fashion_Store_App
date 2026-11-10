import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../features/orders/presentation/cubit/order_state.dart';

class OrdersFilterList extends StatelessWidget {
  final String selectedStatus;
  final OrderState state;
  final ValueChanged<String> onStatusSelected;

  const OrdersFilterList({
    super.key,
    required this.selectedStatus,
    required this.state,
    required this.onStatusSelected,
  });

  static const List<String> _statuses = [
    'All',
    'Pending',
    'Confirmed',
    'Shipped',
    'Delivered',
    'Cancelled',
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 58,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 8,
        ),
        scrollDirection: Axis.horizontal,
        itemCount: _statuses.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final status = _statuses[index];
          final isSelected = selectedStatus == status;
          final count = state.getOrderCountByStatus(status);

          return ChoiceChip(
            label: Text('$status ($count)'),
            selected: isSelected,
            onSelected: (_) => onStatusSelected(status),
            selectedColor: AppColors.primary,
            backgroundColor: AppColors.white,
            labelStyle: TextStyle(
              color: isSelected
                  ? AppColors.white
                  : AppColors.primary,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
            side: BorderSide(
              color: isSelected
                  ? AppColors.primary
                  : AppColors.lightGrey,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            showCheckmark: false,
          );
        },
      ),
    );
  }
}