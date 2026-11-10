class Order {
  final String id;
  final String customerName;
  final String email;
  final String phone;
  final String address;
  final List<OrderItem> items;
  final double totalPrice;
  final String paymentMethod;
  final String status;
  final DateTime createdAt;

  const Order({
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

  bool get canBeCancelled => status.toLowerCase() == 'pending';
}

class OrderItem {
  final String productId;
  final String productName;
  final String productImage;
  final double price;
  final String size;
  final String color;
  final int quantity;

  const OrderItem({
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.price,
    required this.size,
    required this.color,
    required this.quantity,
  });

  double get totalPrice => price * quantity;
}