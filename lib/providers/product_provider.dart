import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/models/product_model.dart';
import '../data/repositories/product_repository.dart';

class ProductProvider extends ChangeNotifier {
  final ProductRepository _repository = ProductRepository();

  static const int _pageSize = 10;
  static const String _favoritesStorageKey = 'mode_saved_products';

  List<ProductModel> _products = [];

  final Map<String, ProductModel> _favoriteProducts = {};
  final Map<String, int> _categoryIds = {};

  bool _isLoading = true;
  bool _isLoadingMore = false;
  bool _hasMore = true;

  int _offset = 0;
  int _requestVersion = 0;

  int? _selectedCategoryId;
  String _selectedCategory = 'All';

  String? _errorMessage;
  String? _loadMoreError;

  Future<void> _saveQueue = Future.value();

  List<ProductModel> get products => List.unmodifiable(_products);

  List<String> get categories => [
        'All',
        ..._categoryIds.keys,
      ];

  String get selectedCategory => _selectedCategory;

  Set<String> get favoriteProductIds =>
      Set.unmodifiable(_favoriteProducts.keys.toSet());

  List<ProductModel> get favoriteProducts =>
      List.unmodifiable(_favoriteProducts.values);

  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMore => _hasMore;

  String? get errorMessage => _errorMessage;
  String? get loadMoreError => _loadMoreError;

  ProductProvider() {
    _initialize();
  }

  Future<void> _initialize() async {
    await _loadFavorites();
    await _loadCategories();
    await loadProducts();
  }

  Future<void> _loadCategories() async {
    try {
      final categoriesData = await _repository.getCategories();

      _categoryIds.clear();

      for (final category in categoriesData) {
        final id = category['id'];
        final name = category['name']?.toString().trim();

        if (id is num && name != null && name.isNotEmpty) {
          _categoryIds[name] = id.toInt();
        }
      }

      debugPrint('Categories loaded: ${_categoryIds.keys.toList()}');
    } catch (error) {
      debugPrint('Failed to load categories: $error');
    }

    notifyListeners();
  }

  Future<void> _loadFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedFavorites = prefs.getString(_favoritesStorageKey);

      if (savedFavorites == null) return;

      final decodedData = jsonDecode(savedFavorites);

      if (decodedData is! List) return;

      _favoriteProducts.clear();

      for (final item in decodedData) {
        if (item is! Map) continue;

        final product = ProductModel.fromJson(
          Map<String, dynamic>.from(item),
        );

        _favoriteProducts[product.id] = product;
      }

      debugPrint(
        'Favorites restored: ${_favoriteProducts.length} products',
      );
    } catch (error) {
      debugPrint('Failed to restore favorites: $error');
    }

    notifyListeners();
  }

  Future<void> _saveFavorites() {
    _saveQueue = _saveQueue.then((_) async {
      try {
        final prefs = await SharedPreferences.getInstance();

        final favoritesData = _favoriteProducts.values
            .map((product) => product.toJson())
            .toList();

        await prefs.setString(
          _favoritesStorageKey,
          jsonEncode(favoritesData),
        );
      } catch (error) {
        debugPrint('Failed to save favorites: $error');
      }
    });

    return _saveQueue;
  }

  Future<void> selectCategory(String category) async {
    if (category != 'All' && !_categoryIds.containsKey(category)) {
      return;
    }

    if (_selectedCategory == category) return;

    _selectedCategory = category;
    _selectedCategoryId = category == 'All'
        ? null
        : _categoryIds[category];

    _products = [];
    _offset = 0;
    _hasMore = true;
    _loadMoreError = null;

    notifyListeners();

    await loadProducts();
  }

  Future<void> loadProducts() async {
    final requestVersion = ++_requestVersion;

    _isLoading = true;
    _isLoadingMore = false;
    _errorMessage = null;
    _loadMoreError = null;

    _offset = 0;
    _hasMore = true;

    notifyListeners();

    try {
      final fetchedProducts = _selectedCategoryId == null
          ? await _repository.getProducts(
              limit: _pageSize,
              offset: 0,
            )
          : await _repository.getProductsByCategory(
              categoryId: _selectedCategoryId!,
              limit: _pageSize,
              offset: 0,
            );

      if (requestVersion != _requestVersion) return;

      _products = fetchedProducts;
      _offset = fetchedProducts.length;
      _hasMore = fetchedProducts.length == _pageSize;

      debugPrint(
        'Products loaded for $_selectedCategory: ${_products.length}',
      );
    } catch (error, stackTrace) {
      if (requestVersion != _requestVersion) return;

      _errorMessage = 'Failed to load products: $error';

      debugPrint('Load products error: $error');
      debugPrintStack(stackTrace: stackTrace);
    } finally {
      if (requestVersion == _requestVersion) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  Future<void> refreshProducts() async {
    await loadProducts();
  }

  Future<void> loadMoreProducts() async {
    if (_isLoading || _isLoadingMore || !_hasMore) return;

    final requestVersion = _requestVersion;

    _isLoadingMore = true;
    _loadMoreError = null;

    notifyListeners();

    try {
      final fetchedProducts = _selectedCategoryId == null
          ? await _repository.getProducts(
              limit: _pageSize,
              offset: _offset,
            )
          : await _repository.getProductsByCategory(
              categoryId: _selectedCategoryId!,
              limit: _pageSize,
              offset: _offset,
            );

      if (requestVersion != _requestVersion) return;

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

      debugPrint('Loaded more products. Total: ${_products.length}');
    } catch (error, stackTrace) {
      if (requestVersion != _requestVersion) return;

      _loadMoreError = 'Failed to load more products.';

      debugPrint('Load more products error: $error');
      debugPrintStack(stackTrace: stackTrace);
    } finally {
      if (requestVersion == _requestVersion) {
        _isLoadingMore = false;
        notifyListeners();
      }
    }
  }

  bool isFavorite(String productId) {
    return _favoriteProducts.containsKey(productId);
  }

  void toggleFavorite(String productId) {
    if (_favoriteProducts.containsKey(productId)) {
      _favoriteProducts.remove(productId);
    } else {
      ProductModel? product;

      for (final item in _products) {
        if (item.id == productId) {
          product = item;
          break;
        }
      }

      if (product == null) return;

      _favoriteProducts[productId] = product;
    }

    notifyListeners();
    _saveFavorites();
  }
}