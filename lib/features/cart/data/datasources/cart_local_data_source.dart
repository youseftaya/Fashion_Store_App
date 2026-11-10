import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/cart_item_model.dart';

class CartLocalDataSource {
  static const String _cartStorageKey = 'mode_cart_items';

  Future<void> _saveQueue = Future.value();

  Future<List<CartItemModel>> getCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    final savedCart = prefs.getString(_cartStorageKey);

    if (savedCart == null) return [];

    final decodedData = jsonDecode(savedCart);

    if (decodedData is! List) return [];

    return decodedData
        .whereType<Map>()
        .map(
          (item) => CartItemModel.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
        .toList();
  }

  Future<void> saveCartItems(List<CartItemModel> items) {
    _saveQueue = _saveQueue.then((_) async {
      final prefs = await SharedPreferences.getInstance();

      final cartData = items.map((item) => item.toJson()).toList();

      await prefs.setString(
        _cartStorageKey,
        jsonEncode(cartData),
      );
    });

    return _saveQueue;
  }
}