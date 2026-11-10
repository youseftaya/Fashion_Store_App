class Product {
  final String id;
  final String name;
  final String category;
  final String imageUrl;
  final String description;
  final double price;
  final double discountPercentage;
  final double rating;

  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.imageUrl,
    this.description = '',
    required this.price,
    this.discountPercentage = 0,
    this.rating = 0,
  });
}