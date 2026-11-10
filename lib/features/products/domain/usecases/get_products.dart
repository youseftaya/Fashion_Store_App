import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetProducts {
  final ProductRepository repository;

  const GetProducts(this.repository);

  Future<List<Product>> call({
    int limit = 10,
    int offset = 0,
  }) {
    return repository.getProducts(
      limit: limit,
      offset: offset,
    );
  }
}