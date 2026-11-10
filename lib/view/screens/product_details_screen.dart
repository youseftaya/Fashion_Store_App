import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/product_model.dart';

import '../../features/cart/presentation/cubit/cart_cubit.dart';
import '../../features/products/presentation/cubit/product_details/product_details_cubit.dart';
import '../../features/products/presentation/cubit/product_details/product_details_state.dart';

import '../widgets/product_details_header.dart';
import '../widgets/product_image_view.dart';
import '../widgets/product_size_selector.dart';
import '../widgets/product_color_selector.dart';
import '../widgets/product_quantity_selector.dart';
import '../widgets/product_add_to_cart_button.dart';

class ProductDetailsScreen extends StatelessWidget {
  final ProductModel product;

  const ProductDetailsScreen({
    super.key,
    required this.product,
  });

  static const List<String> _sizes = ['S', 'M', 'L', 'XL'];

  static const List<Color> _colors = [
    Colors.black,
    Colors.white,
    Colors.brown,
    Colors.grey,
    Colors.blue,
  ];

  String _colorName(Color color) {
    if (color == Colors.black) return 'Black';
    if (color == Colors.white) return 'White';
    if (color == Colors.brown) return 'Brown';
    if (color == Colors.grey) return 'Grey';
    if (color == Colors.blue) return 'Blue';
    return 'Black';
  }

  Future<void> _addToCart(
    BuildContext context,
    ProductDetailsState state,
  ) async {
    if (state.selectedSize == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a size first.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    await context.read<CartCubit>().addToCart(
          product,
          size: state.selectedSize!,
          color: _colorName(state.selectedColor),
          quantity: state.quantity,
        );

    if (!context.mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('${product.name} added to cart.'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.primary,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProductDetailsCubit(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: AppColors.background,
            body: SafeArea(
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: ProductDetailsHeader(product: product),
                  ),
                  SliverToBoxAdapter(
                    child: ProductImageView(product: product),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        Text(
                          product.category.toUpperCase(),
                          style: const TextStyle(
                            color: AppColors.secondary,
                            fontSize: 11,
                            letterSpacing: 2,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          product.name,
                          style: AppTextStyles.sectionTitle.copyWith(
                            fontSize: 24,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 19,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              product.rating > 0
                                  ? product.rating.toStringAsFixed(1)
                                  : 'Not rated',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: AppTextStyles.price.copyWith(fontSize: 22),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'PRODUCT DESCRIPTION',
                          style: TextStyle(
                            fontSize: 12,
                            letterSpacing: 1.4,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          product.description.trim().isNotEmpty
                              ? product.description
                              : 'A stylish addition to your wardrobe.',
                          style: const TextStyle(
                            color: AppColors.secondary,
                            fontSize: 14,
                            height: 1.7,
                          ),
                        ),
                        const SizedBox(height: 28),
                        BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
                          builder: (context, state) {
                            return ProductSizeSelector(
                              sizes: _sizes,
                              selectedSize: state.selectedSize,
                              onSizeSelected: context
                                  .read<ProductDetailsCubit>()
                                  .selectSize,
                            );
                          },
                        ),
                        const SizedBox(height: 28),
                        BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
                          builder: (context, state) {
                            return ProductColorSelector(
                              colors: _colors,
                              selectedColor: state.selectedColor,
                              onColorSelected: context
                                  .read<ProductDetailsCubit>()
                                  .selectColor,
                            );
                          },
                        ),
                        const SizedBox(height: 28),
                        BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
                          builder: (context, state) {
                            final cubit = context.read<ProductDetailsCubit>();

                            return ProductQuantitySelector(
                              quantity: state.quantity,
                              onDecrease: cubit.decreaseQuantity,
                              onIncrease: cubit.increaseQuantity,
                            );
                          },
                        ),
                        const SizedBox(height: 32),
                        BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
                          builder: (context, state) {
                            return ProductAddToCartButton(
                              onPressed: () => _addToCart(context, state),
                            );
                          },
                        ),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}