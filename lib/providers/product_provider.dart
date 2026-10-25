import 'package:flutter/foundation.dart';

import '../data/models/product_model.dart';
import '../data/repositories/product_repository.dart';

class ProductProvider extends ChangeNotifier {
  final ProductRepository _repository = ProductRepository();

  List<ProductModel> _products = [];
  final Set<String> _favoriteProductIds = {};

  List<ProductModel> get products => List.unmodifiable(_products);

  Set<String> get favoriteProductIds =>
      Set.unmodifiable(_favoriteProductIds);

  List<ProductModel> get favoriteProducts {
    return _products
        .where((product) => _favoriteProductIds.contains(product.id))
        .toList();
  }

  ProductProvider() {
    loadProducts();
  }

  void loadProducts() {
    _products = _repository.getProducts();
    notifyListeners();
  }

  bool isFavorite(String productId) {
    return _favoriteProductIds.contains(productId);
  }

  void toggleFavorite(String productId) {
    if (!_products.any((product) => product.id == productId)) {
      return;
    }

    if (!_favoriteProductIds.add(productId)) {
      _favoriteProductIds.remove(productId);
    }

    notifyListeners();
  }
}