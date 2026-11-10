import '../../../products/data/models/product_model.dart';
import '../../domain/entities/cart_item.dart';

class CartItemModel {
  final ProductModel product;
  final String size;
  final String color;
  final int quantity;

  const CartItemModel({
    required this.product,
    this.size = 'Not selected',
    this.color = 'Not selected',
    this.quantity = 1,
  });

  String get id => '${product.id}_${size}_$color';

  double get totalPrice => product.price * quantity;

  CartItem toEntity() {
    return CartItem(
      product: product,
      size: size,
      color: color,
      quantity: quantity,
    );
  }

  factory CartItemModel.fromEntity(CartItem item) {
    return CartItemModel(
      product: ProductModel(
        id: item.product.id,
        name: item.product.name,
        category: item.product.category,
        imageUrl: item.product.imageUrl,
        description: item.product.description,
        price: item.product.price,
        discountPercentage: item.product.discountPercentage,
        rating: item.product.rating,
      ),
      size: item.size,
      color: item.color,
      quantity: item.quantity,
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
        Map<String, dynamic>.from(json['product']),
      ),
      size: json['size'] ?? 'Not selected',
      color: json['color'] ?? 'Not selected',
      quantity: json['quantity'] ?? 1,
    );
  }
}