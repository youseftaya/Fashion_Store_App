import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/models/cart_item_model.dart';
import '../data/models/order_model.dart';

class OrderProvider extends ChangeNotifier {
  static const String _storageKey = 'mode_orders';

  static const List<String> orderStatuses = [
    'All',
    'Pending',
    'Confirmed',
    'Shipped',
    'Delivered',
    'Cancelled',
  ];

  final List<OrderModel> _orders = [];

  bool _isLoading = false;

  Future<void> _saveQueue = Future<void>.value();

  OrderProvider() {
    loadOrders();
  }

  List<OrderModel> get orders => List.unmodifiable(_orders);

  bool get isLoading => _isLoading;

  int get orderCount => _orders.length;

  // Filter orders by status.
  List<OrderModel> getOrdersByStatus(String status) {
    if (status.toLowerCase() == 'all') {
      return orders;
    }

    return _orders
        .where(
          (order) =>
              order.status.toLowerCase() == status.toLowerCase(),
        )
        .toList();
  }

  // Count orders for a specific status.
  int getOrderCountByStatus(String status) {
    if (status.toLowerCase() == 'all') {
      return _orders.length;
    }

    return _orders
        .where(
          (order) =>
              order.status.toLowerCase() == status.toLowerCase(),
        )
        .length;
  }

  // Check whether an order can be cancelled.
  bool canCancelOrder(OrderModel order) {
    return order.status.toLowerCase() == 'pending';
  }

  Future<void> loadOrders() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final savedOrders = prefs.getString(_storageKey);

      if (savedOrders == null) return;

      final decodedData = jsonDecode(savedOrders);

      if (decodedData is! List) return;

      _orders
        ..clear()
        ..addAll(
          decodedData.map(
            (item) => OrderModel.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          ),
        );

      debugPrint('Orders restored: ${_orders.length}');
    } catch (error) {
      debugPrint('Failed to restore orders: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _saveOrders() {
    // Recover the queue if an earlier save failed.
    _saveQueue = _saveQueue
        .catchError((_) {})
        .then((_) async {
          final prefs = await SharedPreferences.getInstance();

          final ordersData = _orders
              .map((order) => order.toJson())
              .toList();

          final success = await prefs.setString(
            _storageKey,
            jsonEncode(ordersData),
          );

          if (!success) {
            throw Exception('Could not save orders.');
          }
        });

    return _saveQueue;
  }

  Future<OrderModel> placeOrder({
    required String customerName,
    required String email,
    required String phone,
    required String address,
    required List<CartItemModel> items,
    required double totalPrice,
  }) async {
    if (items.isEmpty) {
      throw Exception('Your cart is empty.');
    }

    final order = OrderModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      customerName: customerName.trim(),
      email: email.trim(),
      phone: phone.trim(),
      address: address.trim(),
      items: items.map((item) => item.copyWith()).toList(),
      totalPrice: totalPrice,
      createdAt: DateTime.now(),
    );

    _orders.insert(0, order);

    try {
      await _saveOrders();
      notifyListeners();
      return order;
    } catch (error) {
      _orders.removeWhere((item) => item.id == order.id);
      rethrow;
    }
  }

  // Cancel a pending order and save the new status.
  Future<bool> cancelOrder(String orderId) async {
    final index = _orders.indexWhere(
      (order) => order.id == orderId,
    );

    if (index == -1) return false;

    final oldOrder = _orders[index];

    if (!canCancelOrder(oldOrder)) {
      return false;
    }

    final cancelledOrder = OrderModel(
      id: oldOrder.id,
      customerName: oldOrder.customerName,
      email: oldOrder.email,
      phone: oldOrder.phone,
      address: oldOrder.address,
      items: oldOrder.items,
      totalPrice: oldOrder.totalPrice,
      paymentMethod: oldOrder.paymentMethod,
      status: 'Cancelled',
      createdAt: oldOrder.createdAt,
    );

    _orders[index] = cancelledOrder;

    try {
      await _saveOrders();
      notifyListeners();
      return true;
    } catch (error) {
      _orders[index] = oldOrder;
      notifyListeners();
      debugPrint('Failed to cancel order: $error');
      rethrow;
    }
  }

  OrderModel? getOrderById(String id) {
    try {
      return _orders.firstWhere((order) => order.id == id);
    } catch (_) {
      return null;
    }
  }
}