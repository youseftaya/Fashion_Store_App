import '../repositories/order_repository.dart';

class CancelOrder {
  final OrderRepository repository;

  const CancelOrder(this.repository);

  Future<bool> call(String orderId) {
    return repository.cancelOrder(orderId);
  }
}