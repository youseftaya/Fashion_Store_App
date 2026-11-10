import '../../domain/entities/cart_item.dart';

enum CartStatus {
  initial,
  loading,
  success,
  failure,
}

class CartState {
  final CartStatus status;
  final List<CartItem> items;
  final String? errorMessage;

  const CartState({
    this.status = CartStatus.initial,
    this.items = const [],
    this.errorMessage,
  });

  int get itemCount {
    return items.fold<int>(
      0,
      (total, item) => total + item.quantity,
    );
  }

  double get totalPrice {
    return items.fold<double>(
      0.0,
      (total, item) => total + item.totalPrice,
    );
  }

  bool containsProduct(String productId) {
    return items.any(
      (item) => item.product.id == productId,
    );
  }

  CartState copyWith({
    CartStatus? status,
    List<CartItem>? items,
    String? errorMessage,
  }) {
    return CartState(
      status: status ?? this.status,
      items: items ?? this.items,
      errorMessage: errorMessage,
    );
  }
}