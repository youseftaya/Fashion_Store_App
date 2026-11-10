import 'dart:async';
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/product.dart';
import '../../domain/usecases/get_categories.dart';
import '../../domain/usecases/get_products.dart';
import '../../domain/usecases/get_products_by_category.dart';
import 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  final GetProducts getProducts;
  final GetProductsByCategory getProductsByCategory;
  final GetCategories getCategories;

  static const int _pageSize = 10;
  static const String _favoritesStorageKey = 'mode_saved_products';

  int _offset = 0;
  int _requestVersion = 0;

  Future<void> _saveQueue = Future.value();

  ProductsCubit({
    required this.getProducts,
    required this.getProductsByCategory,
    required this.getCategories,
  }) : super(ProductsState()) {
    initialize();
  }

  Future<void> initialize() async {
    await _loadFavorites();
    if (isClosed) return;

    await _loadCategories();
    if (isClosed) return;

    await loadProducts();
  }

  Future<void> _loadFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedFavorites = prefs.getString(_favoritesStorageKey);

      if (savedFavorites == null) return;

      final decodedData = jsonDecode(savedFavorites);

      if (decodedData is! List) return;

      final favorites = <String, Product>{};

      for (final item in decodedData) {
        if (item is! Map) continue;

        final data = Map<String, dynamic>.from(item);

        final product = Product(
          id: data['id'].toString(),
          name: (data['title'] ?? data['name'] ?? 'Unnamed Product')
              .toString(),
          category: data['category'] is Map
              ? data['category']['name']?.toString() ?? 'Other'
              : data['category']?.toString() ?? 'Other',
          imageUrl: data['imageUrl']?.toString() ?? '',
          description: data['description']?.toString() ?? '',
          price: (data['price'] as num?)?.toDouble() ?? 0.0,
          discountPercentage:
              (data['discountPercentage'] as num?)?.toDouble() ?? 0.0,
          rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
        );

        favorites[product.id] = product;
      }

      emit(state.copyWith(favoriteProducts: favorites));
    } catch (_) {
      // Keep the app running if saved favorites cannot be restored.
    }
  }

  Future<void> _saveFavorites() {
    _saveQueue = _saveQueue.then((_) async {
      try {
        final prefs = await SharedPreferences.getInstance();

        final favoritesData = state.favoriteProducts.values.map((product) {
          return {
            'id': product.id,
            'title': product.name,
            'category': product.category,
            'imageUrl': product.imageUrl,
            'description': product.description,
            'price': product.price,
            'discountPercentage': product.discountPercentage,
            'rating': product.rating,
          };
        }).toList();

        await prefs.setString(
          _favoritesStorageKey,
          jsonEncode(favoritesData),
        );
      } catch (_) {
        // Saving favorites is best-effort.
      }
    });

    return _saveQueue;
  }

  Future<void> _loadCategories() async {
    try {
      final categoriesData = await getCategories();

      final categoryIds = <String, int>{};

      for (final category in categoriesData) {
        final id = category['id'];
        final name = category['name']?.toString().trim();

        if (id is num && name != null && name.isNotEmpty) {
          categoryIds[name] = id.toInt();
        }
      }

      emit(
        state.copyWith(
          categoryIds: categoryIds,
          categories: ['All', ...categoryIds.keys],
        ),
      );
    } catch (_) {
      // Categories remain available with the default All option.
    }
  }

  Future<void> selectCategory(String category) async {
    if (category != 'All' && !state.categoryIds.containsKey(category)) {
      return;
    }

    if (state.selectedCategory == category) return;

    final categoryId =
        category == 'All' ? null : state.categoryIds[category];

    _offset = 0;

    emit(
      state.copyWith(
        selectedCategory: category,
        selectedCategoryId: categoryId,
        clearSelectedCategoryId: category == 'All',
        products: [],
        hasMore: true,
        clearLoadMoreError: true,
      ),
    );

    await loadProducts();
  }

  Future<void> loadProducts() async {
    final requestVersion = ++_requestVersion;

    _offset = 0;

    emit(
      state.copyWith(
        isLoading: true,
        isLoadingMore: false,
        hasMore: true,
        clearErrorMessage: true,
        clearLoadMoreError: true,
      ),
    );

    try {
      final fetchedProducts = state.selectedCategoryId == null
          ? await getProducts(limit: _pageSize, offset: 0)
          : await getProductsByCategory(
              categoryId: state.selectedCategoryId!,
              limit: _pageSize,
              offset: 0,
            );

      if (isClosed || requestVersion != _requestVersion) return;

      _offset = fetchedProducts.length;

      emit(
        state.copyWith(
          products: fetchedProducts,
          hasMore: fetchedProducts.length == _pageSize,
          isLoading: false,
        ),
      );
    } catch (error) {
      if (isClosed || requestVersion != _requestVersion) return;

      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to load products: $error',
        ),
      );
    }
  }

  Future<void> refreshProducts() async {
    await loadProducts();
  }

  Future<void> loadMoreProducts() async {
    if (state.isLoading ||
        state.isLoadingMore ||
        !state.hasMore) {
      return;
    }

    final requestVersion = _requestVersion;

    emit(
      state.copyWith(
        isLoadingMore: true,
        clearLoadMoreError: true,
      ),
    );

    try {
      final fetchedProducts = state.selectedCategoryId == null
          ? await getProducts(limit: _pageSize, offset: _offset)
          : await getProductsByCategory(
              categoryId: state.selectedCategoryId!,
              limit: _pageSize,
              offset: _offset,
            );

      if (isClosed || requestVersion != _requestVersion) return;

      if (fetchedProducts.isEmpty) {
        emit(
          state.copyWith(
            hasMore: false,
            isLoadingMore: false,
          ),
        );
        return;
      }

      final existingIds = state.products.map((p) => p.id).toSet();

      final newProducts = fetchedProducts
          .where((product) => !existingIds.contains(product.id))
          .toList();

      _offset += fetchedProducts.length;

      emit(
        state.copyWith(
          products: [...state.products, ...newProducts],
          hasMore: fetchedProducts.length == _pageSize,
          isLoadingMore: false,
        ),
      );
    } catch (_) {
      if (isClosed || requestVersion != _requestVersion) return;

      emit(
        state.copyWith(
          isLoadingMore: false,
          loadMoreError: 'Failed to load more products.',
        ),
      );
    }
  }

  bool isFavorite(String productId) {
    return state.favoriteProducts.containsKey(productId);
  }

  Future<void> toggleFavorite(String productId) async {
    final favorites = Map<String, Product>.from(state.favoriteProducts);

    if (favorites.containsKey(productId)) {
      favorites.remove(productId);
    } else {
      Product? product;

      for (final item in state.products) {
        if (item.id == productId) {
          product = item;
          break;
        }
      }

      if (product == null) return;

      favorites[productId] = product;
    }

    emit(state.copyWith(favoriteProducts: favorites));

    await _saveFavorites();
  }
}