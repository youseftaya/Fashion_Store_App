import '../../../products/domain/entities/product.dart';

class CartItem {
  final Product product;
  final String size;
  final String color;
  final int quantity;

  const CartItem({
    required this.product,
    this.size = 'Not selected',
    this.color = 'Not selected',
    this.quantity = 1,
  });

  String get id => '${product.id}_${size}_$color';

  double get totalPrice => product.price * quantity;

  CartItem copyWith({
    Product? product,
    String? size,
    String? color,
    int? quantity,
  }) {
    return CartItem(
      product: product ?? this.product,
      size: size ?? this.size,
      color: color ?? this.color,
      quantity: quantity ?? this.quantity,
    );
  }
}