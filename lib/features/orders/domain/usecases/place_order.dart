import '../entities/order.dart';
import '../repositories/order_repository.dart';

class PlaceOrder {
  final OrderRepository repository;

  const PlaceOrder(this.repository);

  Future<Order> call({
    required String customerName,
    required String email,
    required String phone,
    required String address,
    required List<OrderItem> items,
    required double totalPrice,
  }) {
    if (items.isEmpty) {
      throw Exception('Your cart is empty.');
    }

    if (totalPrice <= 0) {
      throw Exception('Order total must be greater than zero.');
    }

    return repository.placeOrder(
      customerName: customerName,
      email: email,
      phone: phone,
      address: address,
      items: items,
      totalPrice: totalPrice,
    );
  }
}