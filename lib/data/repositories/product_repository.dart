import '../models/product_model.dart';
import '../services/api_service.dart';

class ProductRepository {
  final ApiService _apiService;

  ProductRepository({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  Future<List<Map<String, dynamic>>> getCategories() async {
    final results = await _apiService.fetchCategories();

    return results
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  Future<List<ProductModel>> getProducts({
    int limit = 10,
    int offset = 0,
  }) async {
    final results = await _apiService.fetchProducts(
      limit: limit,
      offset: offset,
    );

    return _parseProducts(results);
  }

  Future<List<ProductModel>> getProductsByCategory({
    required int categoryId,
    int limit = 10,
    int offset = 0,
  }) async {
    final results = await _apiService.fetchProductsByCategory(
      categoryId: categoryId,
      limit: limit,
      offset: offset,
    );

    return _parseProducts(results);
  }

  List<ProductModel> _parseProducts(List<dynamic> results) {
    return results
        .whereType<Map>()
        .map(
          (item) => ProductModel.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
        .toList();
  }
}