import '../entities/order.dart';
import '../repositories/order_repository.dart';

class GetOrderById {
  final OrderRepository repository;

  const GetOrderById(this.repository);

  Future<Order?> call(String id) {
    return repository.getOrderById(id);
  }
}