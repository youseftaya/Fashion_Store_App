import 'package:flutter/foundation.dart';

import '../data/models/cart_item_model.dart';
import '../data/models/product_model.dart';

class CartProvider extends ChangeNotifier {
  final Map<String, CartItemModel> _items = {};

  List<CartItemModel> get items =>
      _items.values.map((item) => item.copyWith()).toList();

  int get itemCount =>
      _items.values.fold(0, (total, item) => total + item.quantity);

  double get totalPrice =>
      _items.values.fold(0.0, (total, item) => total + item.totalPrice);

  bool containsProduct(String productId) => _items.containsKey(productId);

  void addToCart(ProductModel product) {
    final existingItem = _items[product.id];

    if (existingItem != null) {
      existingItem.quantity++;
    } else {
      _items[product.id] = CartItemModel(
        product: product,
        quantity: 1,
      );
    }

    notifyListeners();
  }

  void increaseQuantity(String productId) {
    final item = _items[productId];
    if (item == null) return;

    item.quantity++;
    notifyListeners();
  }

  void decreaseQuantity(String productId) {
    final item = _items[productId];
    if (item == null) return;

    if (item.quantity > 1) {
      item.quantity--;
    } else {
      _items.remove(productId);
    }

    notifyListeners();
  }

  void removeFromCart(String productId) {
    if (_items.remove(productId) != null) {
      notifyListeners();
    }
  }

  void clearCart() {
    if (_items.isEmpty) return;

    _items.clear();
    notifyListeners();
  }
}