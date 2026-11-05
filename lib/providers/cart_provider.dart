import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/models/cart_item_model.dart';
import '../data/models/product_model.dart';

class CartProvider extends ChangeNotifier {
  static const String _cartStorageKey = 'mode_cart_items';

  final Map<String, CartItemModel> _items = {};

  Future<void> _saveQueue = Future.value();

  CartProvider() {
    loadCart();
  }

  List<CartItemModel> get items =>
      _items.values.map((item) => item.copyWith()).toList();

  int get itemCount =>
      _items.values.fold(0, (total, item) => total + item.quantity);

  double get totalPrice =>
      _items.values.fold(0.0, (total, item) => total + item.totalPrice);

  bool containsProduct(String productId) =>
      _items.values.any((item) => item.product.id == productId);

  Future<void> loadCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedCart = prefs.getString(_cartStorageKey);

      if (savedCart == null) return;

      final decodedData = jsonDecode(savedCart);

      if (decodedData is! List) return;

      _items.clear();

      for (final item in decodedData) {
        if (item is! Map) continue;

        final cartItem = CartItemModel.fromJson(
          Map<String, dynamic>.from(item),
        );

        _items[cartItem.id] = cartItem;
      }

      debugPrint('Cart restored: ${_items.length} items');
    } catch (error) {
      debugPrint('Failed to restore cart: $error');
    } finally {
      notifyListeners();
    }
  }

  Future<void> _saveCart() {
    _saveQueue = _saveQueue.then((_) async {
      try {
        final prefs = await SharedPreferences.getInstance();

        final cartData = _items.values
            .map((item) => item.toJson())
            .toList();

        await prefs.setString(
          _cartStorageKey,
          jsonEncode(cartData),
        );
      } catch (error) {
        debugPrint('Failed to save cart: $error');
      }
    });

    return _saveQueue;
  }

  void addToCart(
    ProductModel product, {
    String size = 'Not selected',
    String color = 'Not selected',
    int quantity = 1,
  }) {
    final cartItem = CartItemModel(
      product: product,
      size: size,
      color: color,
      quantity: quantity,
    );

    final existingItem = _items[cartItem.id];

    if (existingItem != null) {
      existingItem.quantity += quantity;
    } else {
      _items[cartItem.id] = cartItem;
    }

    notifyListeners();
    _saveCart();
  }

  void increaseQuantity(String cartItemId) {
    final item = _items[cartItemId];
    if (item == null) return;

    item.quantity++;

    notifyListeners();
    _saveCart();
  }

  void decreaseQuantity(String cartItemId) {
    final item = _items[cartItemId];
    if (item == null) return;

    if (item.quantity > 1) {
      item.quantity--;
    } else {
      _items.remove(cartItemId);
    }

    notifyListeners();
    _saveCart();
  }

  void removeFromCart(String cartItemId) {
    if (_items.remove(cartItemId) != null) {
      notifyListeners();
      _saveCart();
    }
  }
    Future<void> clearCart() async {
     if (_items.isEmpty) return;

     _items.clear();

     notifyListeners();
     await _saveCart();
    }
   }