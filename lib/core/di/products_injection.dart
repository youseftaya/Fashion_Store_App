import '../../features/products/data/datasources/products_remote_data_source.dart';
import '../../features/products/data/repositories/product_repository_impl.dart';
import '../../features/products/domain/usecases/get_categories.dart';
import '../../features/products/domain/usecases/get_products.dart';
import '../../features/products/domain/usecases/get_products_by_category.dart';
import '../../features/products/presentation/cubit/products_cubit.dart';

ProductsCubit createProductsCubit() {
  final remoteDataSource = ProductsRemoteDataSource();

  final repository = ProductRepositoryImpl(
    remoteDataSource: remoteDataSource,
  );

  return ProductsCubit(
    getProducts: GetProducts(repository),
    getProductsByCategory: GetProductsByCategory(repository),
    getCategories: GetCategories(repository),
  );
}