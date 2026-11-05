import 'product_model.dart';

class CartItemModel {
  final ProductModel product;
  final String size;
  final String color;
  int quantity;

  CartItemModel({
    required this.product,
    this.size = 'Not selected',
    this.color = 'Not selected',
    this.quantity = 1,
  });

  // Each product variation has its own cart ID.
  String get id => '${product.id}_${size}_$color';

  double get totalPrice => product.price * quantity;

  CartItemModel copyWith({
    ProductModel? product,
    String? size,
    String? color,
    int? quantity,
  }) {
    return CartItemModel(
      product: product ?? this.product,
      size: size ?? this.size,
      color: color ?? this.color,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'size': size,
      'color': color,
      'quantity': quantity,
    };
  }

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      product: ProductModel.fromJson(
        Map<String, dynamic>.from(json['product'] as Map),
      ),
      size: json['size']?.toString() ?? 'Not selected',
      color: json['color']?.toString() ?? 'Not selected',
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
    );
  }
}