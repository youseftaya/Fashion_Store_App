import '../entities/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts({
    int limit = 10,
    int offset = 0,
  });

  Future<List<Product>> getProductsByCategory({
    required int categoryId,
    int limit = 10,
    int offset = 0,
  });

  Future<List<Map<String, dynamic>>> getCategories();
}