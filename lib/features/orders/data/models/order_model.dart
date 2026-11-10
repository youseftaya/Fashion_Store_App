import '../../domain/entities/order.dart';

class OrderModel extends Order {
  const OrderModel({
    required super.id,
    required super.customerName,
    required super.email,
    required super.phone,
    required super.address,
    required super.items,
    required super.totalPrice,
    super.paymentMethod,
    super.status,
    required super.createdAt,
  });

  factory OrderModel.fromEntity(Order order) {
    return OrderModel(
      id: order.id,
      customerName: order.customerName,
      email: order.email,
      phone: order.phone,
      address: order.address,
      items: order.items,
      totalPrice: order.totalPrice,
      paymentMethod: order.paymentMethod,
      status: order.status,
      createdAt: order.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerName': customerName,
      'email': email,
      'phone': phone,
      'address': address,
      'items': items.map((item) {
        return {
          'productId': item.productId,
          'productName': item.productName,
          'productImage': item.productImage,
          'price': item.price,
          'size': item.size,
          'color': item.color,
          'quantity': item.quantity,
        };
      }).toList(),
      'totalPrice': totalPrice,
      'paymentMethod': paymentMethod,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id']?.toString() ?? '',
      customerName: json['customerName']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      items: (json['items'] as List? ?? []).map((item) {
        final itemJson = Map<String, dynamic>.from(item as Map);

        // Support the old CartItemModel JSON structure.
        if (itemJson.containsKey('product')) {
          final product = Map<String, dynamic>.from(
            itemJson['product'] as Map,
          );

          return OrderItem(
            productId: product['id']?.toString() ?? '',
            productName: product['name']?.toString() ?? '',
            productImage: product['imageUrl']?.toString() ?? '',
            price: (product['price'] as num?)?.toDouble() ?? 0,
            size: itemJson['size']?.toString() ?? 'Not selected',
            color: itemJson['color']?.toString() ?? 'Not selected',
            quantity: (itemJson['quantity'] as num?)?.toInt() ?? 1,
          );
        }

        return OrderItem(
          productId: itemJson['productId']?.toString() ?? '',
          productName: itemJson['productName']?.toString() ?? '',
          productImage: itemJson['productImage']?.toString() ?? '',
          price: (itemJson['price'] as num?)?.toDouble() ?? 0,
          size: itemJson['size']?.toString() ?? 'Not selected',
          color: itemJson['color']?.toString() ?? 'Not selected',
          quantity: (itemJson['quantity'] as num?)?.toInt() ?? 1,
        );
      }).toList(),
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