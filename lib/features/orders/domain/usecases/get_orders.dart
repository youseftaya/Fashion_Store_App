import '../entities/order.dart';
import '../repositories/order_repository.dart';

class GetOrders {
  final OrderRepository repository;

  const GetOrders(this.repository);

  Future<List<Order>> call() {
    return repository.getOrders();
  }
}