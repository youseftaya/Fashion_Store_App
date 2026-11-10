import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/products_remote_data_source.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductsRemoteDataSource remoteDataSource;

  ProductRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<List<Product>> getProducts({
    int limit = 10,
    int offset = 0,
  }) async {
    final result = await remoteDataSource.fetchProducts(
      limit: limit,
      offset: offset,
    );

    return _mapProducts(result);
  }

  @override
  Future<List<Product>> getProductsByCategory({
    required int categoryId,
    int limit = 10,
    int offset = 0,
  }) async {
    final result = await remoteDataSource.fetchProductsByCategory(
      categoryId: categoryId,
      limit: limit,
      offset: offset,
    );

    return _mapProducts(result);
  }

  @override
  Future<List<Map<String, dynamic>>> getCategories() async {
    final result = await remoteDataSource.fetchCategories();

    return result
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  List<Product> _mapProducts(List<dynamic> result) {
    return result
        .whereType<Map>()
        .map(
          (item) => ProductModel.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
        .toList();
  }
}