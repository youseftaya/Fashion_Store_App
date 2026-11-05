import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/order_model.dart';
import '../screens/order_details_screen.dart';

class OrderCard extends StatelessWidget {
  final OrderModel order;
  final VoidCallback? onCancel;

  const OrderCard({
    super.key,
    required this.order,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final date = order.createdAt;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lightGrey),
      ),
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => OrderDetailsScreen(order: order),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'ORDER #${order.id}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      _StatusBadge(status: order.status),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${date.day.toString().padLeft(2, '0')}/'
                    '${date.month.toString().padLeft(2, '0')}/'
                    '${date.year}  •  '
                    '${date.hour.toString().padLeft(2, '0')}:'
                    '${date.minute.toString().padLeft(2, '0')}',
                    style: const TextStyle(
                      color: AppColors.secondary,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Divider(),
                  const SizedBox(height: 8),

                  ...order.items.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(7),
                            child: Image.network(
                              item.product.imageUrl,
                              width: 52,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 52,
                                  height: 60,
                                  color: AppColors.lightGrey,
                                  child: const Icon(
                                    Icons.image_not_supported_outlined,
                                    size: 18,
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
                                const SizedBox(height: 4),
                                Text(
                                  'Size: ${item.size}  •  Color: ${item.color}',
                                  style: const TextStyle(
                                    color: AppColors.secondary,
                                    fontSize: 10,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  'Qty: ${item.quantity}',
                                  style: const TextStyle(fontSize: 11),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '\$${item.totalPrice.toStringAsFixed(2)}',
                            style: AppTextStyles.price.copyWith(
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const Divider(),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'PAYMENT',
                        style: TextStyle(
                          color: AppColors.secondary,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        order.paymentMethod,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'TOTAL',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        '\$${order.totalPrice.toStringAsFixed(2)}',
                        style: AppTextStyles.price.copyWith(fontSize: 18),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(),
                  const SizedBox(height: 4),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'VIEW DETAILS',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                      SizedBox(width: 5),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 11,
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          if (onCancel != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: onCancel,
                  icon: const Icon(Icons.cancel_outlined, size: 17),
                  label: const Text('CANCEL ORDER'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    padding: const EdgeInsets.symmetric(vertical: 11),
                    textStyle: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final normalized = status.toLowerCase();

    final color = normalized == 'delivered'
        ? Colors.green
        : normalized == 'cancelled'
            ? Colors.red
            : normalized == 'shipped'
                ? Colors.blue
                : Colors.deepOrange;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}