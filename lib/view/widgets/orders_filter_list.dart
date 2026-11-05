import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../providers/order_provider.dart';

class OrdersFilterList extends StatelessWidget {
  final String selectedStatus;
  final ValueChanged<String> onStatusSelected;
  final OrderProvider provider;

  const OrdersFilterList({
    super.key,
    required this.selectedStatus,
    required this.onStatusSelected,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: OrderProvider.orderStatuses.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final status = OrderProvider.orderStatuses[index];
          final isSelected = selectedStatus == status;
          final count = provider.getOrderCountByStatus(status);

          return ChoiceChip(
            label: Text('$status ($count)'),
            selected: isSelected,
            onSelected: (_) => onStatusSelected(status),
            selectedColor: AppColors.primary,
            backgroundColor: AppColors.white,
            labelStyle: TextStyle(
              color: isSelected ? AppColors.white : AppColors.primary,
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