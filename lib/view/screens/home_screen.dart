import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../widgets/category_list.dart';
import '../widgets/empty_state.dart';
import '../widgets/home_bottom_nav.dart';
import '../widgets/home_header.dart';
import '../widgets/product_card.dart';
import '../widgets/promo_banner.dart';
import '../widgets/search_bar_widget.dart';

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

  final Set<String> _favoriteProducts = {};

  final List<String> _categories = const [
    'All',
    'Men',
    'Women',
    'Shoes',
    'Accessories',
  ];

  final List<Map<String, String>> _products = [
    {
      'name': 'Classic Oversized Shirt',
      'category': 'Men',
      'price': '49.00',
      'image':
          'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=600',
    },
    {
      'name': 'Minimal Summer Outfit',
      'category': 'Women',
      'price': '65.00',
      'image':
          'https://images.unsplash.com/photo-1539109136881-3be0616acf4b?w=600',
    },
    {
      'name': 'Essential White Sneakers',
      'category': 'Shoes',
      'price': '79.00',
      'image':
          'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=600',
    },
    {
      'name': 'Everyday Shoulder Bag',
      'category': 'Accessories',
      'price': '39.00',
      'image':
          'https://images.unsplash.com/photo-1584917865442-de89df76afd3?w=600',
    },
  ];

  List<Map<String, String>> get _filteredProducts {
    return _products.where((product) {
      final matchesCategory = _selectedCategory == 'All' ||
          product['category'] == _selectedCategory;

      final matchesSearch = product['name']!
          .toLowerCase()
          .contains(_searchQuery.trim().toLowerCase());

      final matchesFavorites = !_showFavoritesOnly ||
          _favoriteProducts.contains(product['name']);

      return matchesCategory && matchesSearch && matchesFavorites;
    }).toList();
  }

  void _toggleFavorite(String productName) {
    setState(() {
      if (_favoriteProducts.contains(productName)) {
        _favoriteProducts.remove(productName);
      } else {
        _favoriteProducts.add(productName);
      }
    });
  }

  void _selectCategory(String category) {
    setState(() {
      _selectedCategory = category;
      _showFavoritesOnly = false;
      _selectedNavIndex = 0;
    });
  }

  void _selectNavigation(int index) {
    if (index == 2 || index == 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            index == 2
                ? 'Cart screen will be added next.'
                : 'Profile screen will be added next.',
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.primary,
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
    final products = _filteredProducts;

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
                    categories: _categories,
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
                      '${products.length} ITEMS',
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
            if (products.isEmpty)
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
                      final product = products[index];
                      final name = product['name']!;

                      return ProductCard(
                        product: product,
                        isFavorite: _favoriteProducts.contains(name),
                        onFavoriteTap: () => _toggleFavorite(name),
                      );
                    },
                    childCount: products.length,
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
  }
}