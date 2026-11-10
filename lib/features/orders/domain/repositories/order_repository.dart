import '../entities/order.dart';

abstract class OrderRepository {
  Future<List<Order>> getOrders();

  Future<Order> placeOrder({
    required String customerName,
    required String email,
    required String phone,
    required String address,
    required List<OrderItem> items,
    required double totalPrice,
  });

  Future<bool> cancelOrder(String orderId);

  Future<Order?> getOrderById(String id);
}