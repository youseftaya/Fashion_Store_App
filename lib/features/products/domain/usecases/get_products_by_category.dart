import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetProductsByCategory {
  final ProductRepository repository;

  const GetProductsByCategory(this.repository);

  Future<List<Product>> call({
    required int categoryId,
    int limit = 10,
    int offset = 0,
  }) {
    return repository.getProductsByCategory(
      categoryId: categoryId,
      limit: limit,
      offset: offset,
    );
  }
}