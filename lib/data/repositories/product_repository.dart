import '../models/product_model.dart';
import '../services/api_service.dart';

class ProductRepository {
  final ApiService _apiService;

  ProductRepository({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  Future<List<ProductModel>> getProducts({
    int limit = 10,
    int offset = 0,
  }) async {
    final results = await _apiService.fetchProducts(
      limit: limit,
      offset: offset,
    );

    final products = <ProductModel>[];

    for (final item in results) {
      if (item is! Map<String, dynamic>) {
        continue;
      }

      products.add(ProductModel.fromJson(item));
    }

    return products;
  }
}