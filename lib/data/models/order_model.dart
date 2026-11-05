import 'cart_item_model.dart';

class OrderModel {
  final String id;
  final String customerName;
  final String email;
  final String phone;
  final String address;
  final List<CartItemModel> items;
  final double totalPrice;
  final String paymentMethod;
  final String status;
  final DateTime createdAt;

  OrderModel({
    required this.id,
    required this.customerName,
    required this.email,
    required this.phone,
    required this.address,
    required this.items,
    required this.totalPrice,
    this.paymentMethod = 'Cash on Delivery',
    this.status = 'Pending',
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerName': customerName,
      'email': email,
      'phone': phone,
      'address': address,
      'items': items.map((item) => item.toJson()).toList(),
      'totalPrice': totalPrice,
      'paymentMethod': paymentMethod,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'].toString(),
      customerName: json['customerName']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      items: (json['items'] as List? ?? [])
          .map(
            (item) => CartItemModel.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList(),
      totalPrice: (json['totalPrice'] as num?)?.toDouble() ?? 0,
      paymentMethod:
          json['paymentMethod']?.toString() ?? 'Cash on Delivery',
      status: json['status']?.toString() ?? 'Pending',
      createdAt: DateTime.tryParse(
            json['createdAt']?.toString() ?? '',
          ) ??
          DateTime.now(),
    );
  }
}