 import '../repositories/cart_repository.dart';

class UpdateCartQuantity {
  final CartRepository repository;

  UpdateCartQuantity(this.repository);

  Future<void> call(String cartItemId, int quantity) {
    return repository.updateQuantity(cartItemId, quantity);
  }
}