import '../../domain/entities/order.dart';

enum OrderStatus {
  initial,
  loading,
  success,
  failure,
}

class OrderState {
  final OrderStatus status;
  final List<Order> orders;
  final String? errorMessage;

  const OrderState({
    this.status = OrderStatus.initial,
    this.orders = const [],
    this.errorMessage,
  });

  OrderState copyWith({
    OrderStatus? status,
    List<Order>? orders,
    String? errorMessage,
    bool clearError = false,
  }) {
    return OrderState(
      status: status ?? this.status,
      orders: orders ?? this.orders,
      errorMessage: clearError
          ? null
          : errorMessage ?? this.errorMessage,
    );
  }

  bool get isLoading => status == OrderStatus.loading;

  bool get hasError => status == OrderStatus.failure;

  List<Order> getOrdersByStatus(String selectedStatus) {
    if (selectedStatus.toLowerCase() == 'all') {
      return orders;
    }

    return orders
        .where(
          (order) =>
              order.status.toLowerCase() ==
              selectedStatus.toLowerCase(),
        )
        .toList();
  }

  int getOrderCountByStatus(String selectedStatus) {
    return getOrdersByStatus(selectedStatus).length;
  }
}