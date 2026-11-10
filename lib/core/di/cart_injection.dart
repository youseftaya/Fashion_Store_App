import '../../features/cart/data/datasources/cart_local_data_source.dart';
import '../../features/cart/data/repositories/cart_repository_impl.dart';

import '../../features/cart/domain/usecases/add_to_cart.dart';
import '../../features/cart/domain/usecases/clear_cart.dart';
import '../../features/cart/domain/usecases/get_cart_items.dart';
import '../../features/cart/domain/usecases/remove_from_cart.dart';
import '../../features/cart/domain/usecases/update_cart_quantity.dart';

import '../../features/cart/presentation/cubit/cart_cubit.dart';

CartCubit createCartCubit() {
  final localDataSource = CartLocalDataSource();

  final repository = CartRepositoryImpl(
    localDataSource: localDataSource,
  );

  return CartCubit(
    getCartItems: GetCartItems(repository),
    addToCartUseCase: AddToCart(repository),
    updateCartQuantity: UpdateCartQuantity(repository),
    removeFromCart: RemoveFromCart(repository),
    clearCart: ClearCart(repository),
  );
}