import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import 'order_section_card.dart';

class OrderTrackingSection extends StatelessWidget {
  final String status;

  const OrderTrackingSection({
    super.key,
    required this.status,
  });

  static const List<String> _statuses = [
    'Pending',
    'Confirmed',
    'Shipped',
    'Delivered',
  ];

  static const List<IconData> _icons = [
    Icons.receipt_long_outlined,
    Icons.check_circle_outline,
    Icons.local_shipping_outlined,
    Icons.home_outlined,
  ];

  static const List<String> _descriptions = [
    'We have received your order.',
    'Your order has been confirmed.',
    'Your package is on its way.',
    'Your order has been delivered.',
  ];

  @override
  Widget build(BuildContext context) {
    final isCancelled = status.toLowerCase() == 'cancelled';

    final currentIndex = _statuses.indexWhere(
      (item) => item.toLowerCase() == status.toLowerCase(),
    );

    final currentStatusIndex = currentIndex < 0 ? 0 : currentIndex;

    return OrderSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ORDER TRACKING',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.7,
            ),
          ),
          const SizedBox(height: 20),
          if (isCancelled)
            const Row(
              children: [
                Icon(
                  Icons.cancel_outlined,
                  color: Colors.red,
                  size: 28,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'This order has been cancelled.',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            )
          else
            ...List.generate(
              _statuses.length,
              (index) => _buildTimelineStep(
                index,
                currentStatusIndex,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTimelineStep(int index, int currentStatusIndex) {
    final isCompleted = index <= currentStatusIndex;
    final isLast = index == _statuses.length - 1;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 34,
            child: Column(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? AppColors.primary
                        : AppColors.lightGrey,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _icons[index],
                    color: isCompleted
                        ? AppColors.white
                        : AppColors.secondary,
                    size: 17,
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: index < currentStatusIndex
                          ? AppColors.primary
                          : AppColors.lightGrey,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                bottom: 24,
                top: 2,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _statuses[index],
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: isCompleted
                          ? AppColors.primary
                          : AppColors.secondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _descriptions[index],
                    style: const TextStyle(
                      color: AppColors.secondary,
                      fontSize: 11,
                    ),
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