import 'package:flutter/foundation.dart';

import '../data/models/product_model.dart';
import '../data/repositories/product_repository.dart';

class ProductProvider extends ChangeNotifier {
  final ProductRepository _repository = ProductRepository();

  List<ProductModel> _products = [];
  final Set<String> _favoriteProductIds = {};

  bool _isLoading = false;
  String? _errorMessage;

  List<ProductModel> get products => List.unmodifiable(_products);

  Set<String> get favoriteProductIds =>
      Set.unmodifiable(_favoriteProductIds);

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  List<ProductModel> get favoriteProducts {
    return _products
        .where((product) => _favoriteProductIds.contains(product.id))
        .toList();
  }

  ProductProvider() {
    loadProducts();
  }

  Future<void> loadProducts() async {
    if (_isLoading) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _products = await _repository.getProducts();
    } catch (error, stackTrace) {
      _errorMessage = 'Failed to load products. Please try again.';
      debugPrint('Load products error: $error');
      debugPrintStack(stackTrace: stackTrace);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
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