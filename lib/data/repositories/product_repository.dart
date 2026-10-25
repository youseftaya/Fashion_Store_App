import '../models/product_model.dart';

class ProductRepository {
  final List<ProductModel> _products = const [
    ProductModel(
      id: '1',
      name: 'Classic Oversized Shirt',
      category: 'Men',
      imageUrl:
          'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=600',
      price: 49.00,
    ),
    ProductModel(
      id: '2',
      name: 'Minimal Summer Outfit',
      category: 'Women',
      imageUrl:
          'https://images.unsplash.com/photo-1539109136881-3be0616acf4b?w=600',
      price: 65.00,
    ),
    ProductModel(
      id: '3',
      name: 'Essential White Sneakers',
      category: 'Shoes',
      imageUrl:
          'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=600',
      price: 79.00,
    ),
    ProductModel(
      id: '4',
      name: 'Everyday Shoulder Bag',
      category: 'Accessories',
      imageUrl:
          'https://images.unsplash.com/photo-1584917865442-de89df76afd3?w=600',
      price: 39.00,
    ),
  ];

  List<ProductModel> getProducts() {
    return _products;
  }
}