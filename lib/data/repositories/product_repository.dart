import '../models/product_model.dart';
import '../services/api_service.dart';

class ProductRepository {
  final ApiService _apiService;

  ProductRepository({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  static const List<String> _categories = [
    'mens-shirts',
    'mens-shoes',
    'womens-dresses',
    'womens-shoes',
  ];

  Future<List<ProductModel>> getProducts() async {
    final results = await Future.wait(
      _categories.map((category) async {
        try {
          return await _apiService.fetchProducts(
            category: category,
          );
        } catch (error) {
          return <dynamic>[];
        }
      }),
    );

    final productsById = <String, ProductModel>{};

    for (final categoryProducts in results) {
      for (final item in categoryProducts) {
        if (item is! Map<String, dynamic>) {
          continue;
        }

        final product = ProductModel.fromJson(item);
        productsById[product.id] = product;
      }
    }

    return productsById.values.toList();
  }
}