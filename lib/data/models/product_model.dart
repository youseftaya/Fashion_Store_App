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

    final thumbnail = json['thumbnail'] as String?;
    final image = json['image'] as String?;

    final imageUrl = thumbnail != null && thumbnail.isNotEmpty
        ? thumbnail
        : image != null && image.isNotEmpty
            ? image
            : images is List && images.isNotEmpty
                ? images.first.toString()
                : '';

    return ProductModel(
      id: json['id'].toString(),
      name: json['title'] as String? ?? 'Unnamed Product',
      category: json['category'] as String? ?? 'Other',
      imageUrl: imageUrl,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      discountPercentage:
          (json['discountPercentage'] as num?)?.toDouble() ?? 0.0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
    );
  }
}