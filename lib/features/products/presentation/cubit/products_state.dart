import '../../domain/entities/product.dart';

class ProductsState {
  final List<Product> products;
  final List<String> categories;
  final Map<String, int> categoryIds;
  final Map<String, Product> favoriteProducts;

  final String selectedCategory;
  final int? selectedCategoryId;

  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;

  final String? errorMessage;
  final String? loadMoreError;

  ProductsState({
    List<Product> products = const [],
    List<String> categories = const ['All'],
    Map<String, int> categoryIds = const {},
    Map<String, Product> favoriteProducts = const {},
    this.selectedCategory = 'All',
    this.selectedCategoryId,
    this.isLoading = true,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.errorMessage,
    this.loadMoreError,
  })  : products = List.unmodifiable(products),
        categories = List.unmodifiable(categories),
        categoryIds = Map.unmodifiable(categoryIds),
        favoriteProducts = Map.unmodifiable(favoriteProducts);

  Set<String> get favoriteProductIds =>
      favoriteProducts.keys.toSet();

  List<Product> get savedProducts =>
      List.unmodifiable(favoriteProducts.values);

  ProductsState copyWith({
    List<Product>? products,
    List<String>? categories,
    Map<String, int>? categoryIds,
    Map<String, Product>? favoriteProducts,
    String? selectedCategory,
    int? selectedCategoryId,
    bool clearSelectedCategoryId = false,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    String? errorMessage,
    bool clearErrorMessage = false,
    String? loadMoreError,
    bool clearLoadMoreError = false,
  }) {
    return ProductsState(
      products: products ?? this.products,
      categories: categories ?? this.categories,
      categoryIds: categoryIds ?? this.categoryIds,
      favoriteProducts: favoriteProducts ?? this.favoriteProducts,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedCategoryId: clearSelectedCategoryId
          ? null
          : selectedCategoryId ?? this.selectedCategoryId,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      errorMessage:
          clearErrorMessage ? null : errorMessage ?? this.errorMessage,
      loadMoreError: clearLoadMoreError
          ? null
          : loadMoreError ?? this.loadMoreError,
    );
  }
}