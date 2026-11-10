 import '../entities/cart_item.dart';

abstract class CartRepository {
  Future<List<CartItem>> getCartItems();

  Future<void> addToCart(CartItem item);

  Future<void> updateQuantity(
    String cartItemId,
    int quantity,
  );

  Future<void> removeFromCart(String cartItemId);

  Future<void> clearCart();

  Future<void> saveCart();
}