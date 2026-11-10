import '../repositories/product_repository.dart';

class GetCategories {
  final ProductRepository repository;

  const GetCategories(this.repository);

  Future<List<Map<String, dynamic>>> call() {
    return repository.getCategories();
  }
}