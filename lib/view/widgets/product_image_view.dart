import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/product_model.dart';

class ProductImageView extends StatelessWidget {
  final ProductModel product;

  const ProductImageView({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: AspectRatio(
          aspectRatio: 0.82,
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, progress) {
              if (progress == null) return child;

              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return const Center(
                child: Icon(
                  Icons.image_not_supported_outlined,
                  size: 48,
                  color: AppColors.secondary,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}