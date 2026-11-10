import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../products/domain/entities/product.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/usecases/add_to_cart.dart';
import '../../domain/usecases/clear_cart.dart';
import '../../domain/usecases/get_cart_items.dart';
import '../../domain/usecases/remove_from_cart.dart';
import '../../domain/usecases/update_cart_quantity.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final GetCartItems getCartItems;
  final AddToCart addToCartUseCase;
  final UpdateCartQuantity updateCartQuantity;
  final RemoveFromCart removeFromCart;
  final ClearCart clearCart;

  CartCubit({
    required this.getCartItems,
    required this.addToCartUseCase,
    required this.updateCartQuantity,
    required this.removeFromCart,
    required this.clearCart,
  }) : super(const CartState()) {
    loadCart();
  }

  Future<void> loadCart() async {
    emit(state.copyWith(status: CartStatus.loading));

    try {
      final items = await getCartItems();

      emit(
        CartState(
          status: CartStatus.success,
          items: items,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: CartStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> addToCart(
    Product product, {
    String size = 'Not selected',
    String color = 'Not selected',
    int quantity = 1,
  }) async {
    await _performAction(() async {
      final item = CartItem(
        product: product,
        size: size,
        color: color,
        quantity: quantity,
      );

      await addToCartUseCase(item);
    });
  }

  Future<void> increaseQuantity(CartItem item) async {
    await _performAction(() async {
      await updateCartQuantity(
        item.id,
        item.quantity + 1,
      );
    });
  }

  Future<void> decreaseQuantity(CartItem item) async {
    await _performAction(() async {
      await updateCartQuantity(
        item.id,
        item.quantity - 1,
      );
    });
  }

  Future<void> removeItem(String cartItemId) async {
    await _performAction(() async {
      await removeFromCart(cartItemId);
    });
  }

  Future<void> clearCartItems() async {
    await _performAction(() async {
      await clearCart();
    });
  }

  Future<void> _performAction(
    Future<void> Function() action,
  ) async {
    try {
      await action();

      final items = await getCartItems();

      emit(
        CartState(
          status: CartStatus.success,
          items: items,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: CartStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}