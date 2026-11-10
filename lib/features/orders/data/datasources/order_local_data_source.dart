import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/order_model.dart';

abstract class OrderLocalDataSource {
  Future<List<OrderModel>> getOrders();

  Future<void> saveOrders(List<OrderModel> orders);
}

class OrderLocalDataSourceImpl implements OrderLocalDataSource {
  static const String _storageKey = 'mode_orders';

  @override
  Future<List<OrderModel>> getOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final savedOrders = prefs.getString(_storageKey);

    if (savedOrders == null) {
      return [];
    }

    final decodedData = jsonDecode(savedOrders);

    if (decodedData is! List) {
      return [];
    }

    return decodedData.map((item) {
      return OrderModel.fromJson(
        Map<String, dynamic>.from(item as Map),
      );
    }).toList();
  }

  @override
  Future<void> saveOrders(List<OrderModel> orders) async {
    final prefs = await SharedPreferences.getInstance();

    final ordersData = orders
        .map((order) => order.toJson())
        .toList();

    final success = await prefs.setString(
      _storageKey,
      jsonEncode(ordersData),
    );

    if (!success) {
      throw Exception('Could not save orders.');
    }
  }
}