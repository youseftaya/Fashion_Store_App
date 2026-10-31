import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../providers/product_provider.dart';
import '../widgets/category_list.dart';
import '../widgets/empty_state.dart';
import '../widgets/home_bottom_nav.dart';
import '../widgets/home_header.dart';
import '../widgets/product_card.dart';
import '../widgets/promo_banner.dart';
import '../widgets/search_bar_widget.dart';
import 'cart_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCategory = 'All';
  String _searchQuery = '';
  bool _showFavoritesOnly = false;
  int _selectedNavIndex = 0;

  bool _matchesCategory(
    String selectedCategory,
    String productCategory,
  ) {
    if (selectedCategory == 'All') {
      return true;
    }

    return selectedCategory == productCategory;
  }

  void _selectCategory(String category) {
    setState(() {
      _selectedCategory = category;
      _showFavoritesOnly = false;
      _selectedNavIndex = 0;
    });
  }

  void _selectNavigation(int index) {
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
      return;
    }

    setState(() {
      _selectedNavIndex = index;
      _showFavoritesOnly = index == 1;

      if (index == 0) {
        _selectedCategory = 'All';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        final allProducts = productProvider.products;

        final categories = <String>[
          'All',
          ...allProducts
              .map((product) => product.category)
              .where((category) => category.trim().isNotEmpty)
              .toSet()
              .toList()
            ..sort(),
        ];

        if (!categories.contains(_selectedCategory)) {
          _selectedCategory = 'All';
        }

        final filteredProducts = allProducts.where((product) {
          final matchesCategory = _matchesCategory(
            _selectedCategory,
            product.category,
          );

          final matchesSearch = product.name
              .toLowerCase()
              .contains(_searchQuery.trim().toLowerCase());

          final matchesFavorites = !_showFavoritesOnly ||
              productProvider.isFavorite(product.id);

          return matchesCategory &&
              matchesSearch &&
              matchesFavorites;
        }).toList();

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            bottom: false,
            child: CustomScrollView(
              keyboardDismissBehavior:
                  ScrollViewKeyboardDismissBehavior.onDrag,
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: HomeHeader(
                      onProfileTap: () => _selectNavigation(3),
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                    child: SearchBarWidget(
                      query: _searchQuery,
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                      onClear: () {
                        setState(() {
                          _searchQuery = '';
                        });
                      },
                    ),
                  ),
                ),

                if (!_showFavoritesOnly) ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
                      child: CategoryList(
                        categories: categories,
                        selectedCategory: _selectedCategory,
                        onCategorySelected: _selectCategory,
                      ),
                    ),
                  ),

                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(20, 26, 20, 0),
                      child: PromoBanner(),
                    ),
                  ),
                ],

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 28, 20, 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            _showFavoritesOnly
                                ? 'SAVED ITEMS'
                                : _selectedCategory == 'All'
                                    ? 'FEATURED PRODUCTS'
                                    : _selectedCategory.toUpperCase(),
                            style: AppTextStyles.sectionTitle.copyWith(
                              fontSize: 17,
                              letterSpacing: 0.3,
                            ),
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
                ),

                if (productProvider.isLoading && allProducts.isEmpty)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                else if (productProvider.errorMessage != null &&
                    allProducts.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.wifi_off_rounded,
                              size: 42,
                              color: AppColors.secondary,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              productProvider.errorMessage!,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: productProvider.loadProducts,
                              child: const Text('Try Again'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                else if (filteredProducts.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: EmptyState(
                      isFavorites: _showFavoritesOnly,
                      onExplore: () => _selectNavigation(0),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                    sliver: SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
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
                        childCount: filteredProducts.length,
                      ),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 22,
                        childAspectRatio: 0.57,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          bottomNavigationBar: HomeBottomNav(
            selectedIndex: _selectedNavIndex,
            onItemSelected: _selectNavigation,
          ),
        );
      },
    );
  }
}