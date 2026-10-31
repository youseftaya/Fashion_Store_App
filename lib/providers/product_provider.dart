import 'package:flutter/foundation.dart';

import '../data/models/product_model.dart';
import '../data/repositories/product_repository.dart';

class ProductProvider extends ChangeNotifier {
  final ProductRepository _repository = ProductRepository();

  static const int _pageSize = 10;

  List<ProductModel> _products = [];
  final Set<String> _favoriteProductIds = {};

  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMore = true;

  int _offset = 0;

  String? _errorMessage;
  String? _loadMoreError;

  List<ProductModel> get products => List.unmodifiable(_products);

  Set<String> get favoriteProductIds =>
      Set.unmodifiable(_favoriteProductIds);

  bool get isLoading => _isLoading;

  bool get isLoadingMore => _isLoadingMore;

  bool get hasMore => _hasMore;

  String? get errorMessage => _errorMessage;

  String? get loadMoreError => _loadMoreError;

  List<ProductModel> get favoriteProducts {
    return _products
        .where((product) => _favoriteProductIds.contains(product.id))
        .toList();
  }

  ProductProvider() {
    loadProducts();
  }

  // Load the first page.
  Future<void> loadProducts() async {
    if (_isLoading || _isLoadingMore) return;

    _isLoading = true;
    _errorMessage = null;
    _loadMoreError = null;
    notifyListeners();

    try {
      final fetchedProducts = await _repository.getProducts(
        limit: _pageSize,
        offset: 0,
      );

      _products = fetchedProducts;
      _offset = fetchedProducts.length;
      _hasMore = fetchedProducts.length == _pageSize;

      debugPrint(
        'First page loaded: ${_products.length} products',
      );
    } catch (error, stackTrace) {
      _errorMessage = 'Failed to load products: $error';

      debugPrint('Load products error: $error');
      debugPrintStack(stackTrace: stackTrace);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Refresh all products from the first page.
  Future<void> refreshProducts() async {
    await loadProducts();
  }

  // Load the next page.
  Future<void> loadMoreProducts() async {
    if (_isLoading || _isLoadingMore || !_hasMore) return;

    _isLoadingMore = true;
    _loadMoreError = null;
    notifyListeners();

    try {
      final fetchedProducts = await _repository.getProducts(
        limit: _pageSize,
        offset: _offset,
      );

      if (fetchedProducts.isEmpty) {
        _hasMore = false;
        return;
      }

      final existingIds = _products.map((product) => product.id).toSet();

      final newProducts = fetchedProducts
          .where((product) => !existingIds.contains(product.id))
          .toList();

      _products.addAll(newProducts);

      _offset += fetchedProducts.length;
      _hasMore = fetchedProducts.length == _pageSize;

      debugPrint(
        'Loaded more products. Total: ${_products.length}',
      );
    } catch (error, stackTrace) {
      _loadMoreError = 'Failed to load more products.';

      debugPrint('Load more products error: $error');
      debugPrintStack(stackTrace: stackTrace);
    } finally {
      _isLoadingMore = false;
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