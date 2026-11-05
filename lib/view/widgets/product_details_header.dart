import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/product_model.dart';
import '../../providers/product_provider.dart';
import 'circle_icon_button.dart';

class ProductDetailsHeader extends StatelessWidget {
  final ProductModel product;

  const ProductDetailsHeader({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleIconButton(
            icon: Icons.arrow_back,
            onTap: () => Navigator.pop(context),
          ),
          Text(
            'PRODUCT DETAILS',
            style: AppTextStyles.sectionTitle.copyWith(
              fontSize: 13,
              letterSpacing: 1.5,
            ),
          ),
          Consumer<ProductProvider>(
            builder: (context, provider, child) {
              final favorite = provider.isFavorite(product.id);

              return CircleIconButton(
                icon: favorite ? Icons.favorite : Icons.favorite_border,
                iconColor: favorite ? Colors.red : AppColors.black,
                onTap: () => provider.toggleFavorite(product.id),
              );
            },
          ),
        ],
      ),
    );
  }
}