class ProductModel {
  final String id;
  final String name;
  final String category;
  final String imageUrl;
  final String description;
  final double price;
  final double discountPercentage;
  final double rating;

  const ProductModel({
    required this.id,
    required this.name,
    required this.category,
    required this.imageUrl,
    this.description = '',
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
    } else if (json['imageUrl'] != null) {
      imageUrl = json['imageUrl'].toString();
    }

    String category = 'Other';

    if (categoryData is Map<String, dynamic>) {
      category = categoryData['name']?.toString() ?? 'Other';
    } else if (categoryData is String) {
      category = categoryData;
    }

    return ProductModel(
      id: json['id'].toString(),
      name: (json['title'] ?? json['name'] ?? 'Unnamed Product')
          .toString(),
      category: category,
      imageUrl: imageUrl,
      description: json['description']?.toString() ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      discountPercentage:
          (json['discountPercentage'] as num?)?.toDouble() ?? 0.0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': name,
      'category': category,
      'imageUrl': imageUrl,
      'description': description,
      'price': price,
      'discountPercentage': discountPercentage,
      'rating': rating,
    };
  }
}