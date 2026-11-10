import '../../domain/entities/cart_item.dart';
import '../../domain/repositories/cart_repository.dart';
import '../datasources/cart_local_data_source.dart';
import '../models/cart_item_model.dart';

class CartRepositoryImpl implements CartRepository {
  final CartLocalDataSource localDataSource;

  CartRepositoryImpl({
    required this.localDataSource,
  });

  final Map<String, CartItem> _items = {};

  @override
  Future<List<CartItem>> getCartItems() async {
    final savedItems = await localDataSource.getCartItems();

    _items
      ..clear()
      ..addEntries(
        savedItems.map(
          (item) => MapEntry(
            item.id,
            item.toEntity(),
          ),
        ),
      );

    return _items.values.toList();
  }

  @override
  Future<void> addToCart(CartItem item) async {
    final existingItem = _items[item.id];

    if (existingItem != null) {
      _items[item.id] = existingItem.copyWith(
        quantity: existingItem.quantity + item.quantity,
      );
    } else {
      _items[item.id] = item;
    }

    await saveCart();
  }

  @override
  Future<void> updateQuantity(
    String cartItemId,
    int quantity,
  ) async {
    final item = _items[cartItemId];

    if (item == null) return;

    if (quantity <= 0) {
      _items.remove(cartItemId);
    } else {
      _items[cartItemId] = item.copyWith(
        quantity: quantity,
      );
    }

    await saveCart();
  }

  @override
  Future<void> removeFromCart(String cartItemId) async {
    _items.remove(cartItemId);
    await saveCart();
  }

  @override
  Future<void> clearCart() async {
    _items.clear();
    await saveCart();
  }

  @override
  Future<void> saveCart() async {
    final models = _items.values
        .map(CartItemModel.fromEntity)
        .toList();

    await localDataSource.saveCartItems(models);
  }
}