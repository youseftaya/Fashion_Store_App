class ProductModel {
  final String id;
  final String name;
  final String category;
  final String imageUrl;
  final double price;
  final double discountPercentage;
  final double rating;

  const ProductModel({
    required this.id,
    required this.name,
    required this.category,
    required this.imageUrl,
    required this.price,
    this.discountPercentage = 0,
    this.rating = 0,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final images = json['images'];
    final categoryData = json['category'];

    String imageUrl = '';

    if (images is List && images.isNotEmpty) {
      imageUrl = images.first.toString();
    }

    String category = 'Other';

    if (categoryData is Map<String, dynamic>) {
      category = categoryData['name']?.toString() ?? 'Other';
    } else if (categoryData is String) {
      category = categoryData;
    }

    return ProductModel(
      id: json['id'].toString(),
      name: json['title']?.toString() ?? 'Unnamed Product',
      category: category,
      imageUrl: imageUrl,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      discountPercentage:
          (json['discountPercentage'] as num?)?.toDouble() ?? 0.0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
    );
  }
}