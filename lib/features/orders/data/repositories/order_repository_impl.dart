import '../../domain/entities/order.dart';
import '../../domain/repositories/order_repository.dart';
import '../datasources/order_local_data_source.dart';
import '../models/order_model.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderLocalDataSource localDataSource;

  OrderRepositoryImpl({
    required this.localDataSource,
  });

  @override
  Future<List<Order>> getOrders() async {
    return await localDataSource.getOrders();
  }

  @override
  Future<Order> placeOrder({
    required String customerName,
    required String email,
    required String phone,
    required String address,
    required List<OrderItem> items,
    required double totalPrice,
  }) async {
    final orders = await localDataSource.getOrders();

    final order = Order(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      customerName: customerName.trim(),
      email: email.trim(),
      phone: phone.trim(),
      address: address.trim(),
      items: List.unmodifiable(items),
      totalPrice: totalPrice,
      createdAt: DateTime.now(),
    );

    orders.insert(0, OrderModel.fromEntity(order));

    await localDataSource.saveOrders(orders);

    return order;
  }

  @override
  Future<bool> cancelOrder(String orderId) async {
    final orders = await localDataSource.getOrders();

    final index = orders.indexWhere(
      (order) => order.id == orderId,
    );

    if (index == -1) return false;

    final oldOrder = orders[index];

    if (!oldOrder.canBeCancelled) {
      return false;
    }

    final cancelledOrder = OrderModel(
      id: oldOrder.id,
      customerName: oldOrder.customerName,
      email: oldOrder.email,
      phone: oldOrder.phone,
      address: oldOrder.address,
      items: oldOrder.items,
      totalPrice: oldOrder.totalPrice,
      paymentMethod: oldOrder.paymentMethod,
      status: 'Cancelled',
      createdAt: oldOrder.createdAt,
    );

    orders[index] = cancelledOrder;

    await localDataSource.saveOrders(orders);

    return true;
  }

  @override
  Future<Order?> getOrderById(String id) async {
    final orders = await localDataSource.getOrders();

    try {
      return orders.firstWhere((order) => order.id == id);
    } catch (_) {
      return null;
    }
  }
}