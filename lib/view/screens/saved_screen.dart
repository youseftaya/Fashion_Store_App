import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../providers/product_provider.dart';
import '../widgets/empty_state.dart';
import '../widgets/home_bottom_nav.dart';
import '../widgets/product_card.dart';
import 'cart_screen.dart';
import 'profile_screen.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  String _searchQuery = '';

  void _selectNavigation(int index) {
    if (index == 0) {
      Navigator.pop(context);
      return;
    }

    if (index == 1) return;

    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const CartScreen(),
        ),
      );
      return;
    }

    if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const ProfileScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        final savedProducts = productProvider.favoriteProducts;

        final filteredProducts = savedProducts.where((product) {
          return product.name
              .toLowerCase()
              .contains(_searchQuery.trim().toLowerCase());
        }).toList();

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.background,
            elevation: 0,
            centerTitle: false,
            title: Text(
              'MY SAVED ITEMS',
              style: AppTextStyles.sectionTitle.copyWith(
                fontSize: 18,
                letterSpacing: 0.8,
              ),
            ),
          ),
          body: SafeArea(
            top: false,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Search saved products...',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: AppColors.background,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'SAVED ITEMS',
                        style: AppTextStyles.sectionTitle.copyWith(
                          fontSize: 16,
                          letterSpacing: 0.5,
                        ),
                      ),
                      Text(
                        '${filteredProducts.length} ITEMS',
                        style: const TextStyle(
                          color: AppColors.secondary,
                          fontSize: 10,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                Expanded(
                  child: filteredProducts.isEmpty
                      ? EmptyState(
                          isFavorites: true,
                          onExplore: () => Navigator.pop(context),
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.fromLTRB(
                            20,
                            0,
                            20,
                            24,
                          ),
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: filteredProducts.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 14,
                            mainAxisSpacing: 22,
                            childAspectRatio: 0.57,
                          ),
                          itemBuilder: (context, index) {
                            final product = filteredProducts[index];

                            return ProductCard(
                              product: product,
                              isFavorite:
                                  productProvider.isFavorite(product.id),
                              onFavoriteTap: () {
                                productProvider.toggleFavorite(product.id);
                              },
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: HomeBottomNav(
            selectedIndex: 1,
            onItemSelected: _selectNavigation,
          ),
        );
      },
    );
  }
}