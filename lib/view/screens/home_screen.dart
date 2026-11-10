import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../features/products/presentation/cubit/products_cubit.dart';
import '../../features/products/presentation/cubit/products_state.dart';

import '../widgets/category_list.dart';
import '../widgets/empty_state.dart';
import '../widgets/home_bottom_nav.dart';
import '../widgets/home_header.dart';
import '../widgets/product_card.dart';
import '../widgets/promo_banner.dart';
import '../widgets/search_bar_widget.dart';

import 'cart_screen.dart';
import 'profile_screen.dart';
import 'saved_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _searchQuery = '';
  int _selectedNavIndex = 0;

  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController()
      ..addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    if (_scrollController.position.extentAfter < 500) {
      context.read<ProductsCubit>().loadMoreProducts();
    }
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();

    super.dispose();
  }

  void _selectCategory(String category) {
    context.read<ProductsCubit>().selectCategory(category);

    setState(() {
      _selectedNavIndex = 0;
    });

    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0);
    }
  }

  void _selectNavigation(int index) {
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const SavedScreen(),
        ),
      );
      return;
    }

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
      _selectedNavIndex = 0;
    });

    _selectCategory('All');
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductsCubit, ProductsState>(
      builder: (context, state) {
        final allProducts = state.products;

        final filteredProducts = allProducts.where((product) {
          return product.name
              .toLowerCase()
              .contains(_searchQuery.trim().toLowerCase());
        }).toList();

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            bottom: false,
            child: RefreshIndicator(
              color: Theme.of(context).colorScheme.primary,
              backgroundColor: AppColors.background,
              onRefresh: () {
                return context
                    .read<ProductsCubit>()
                    .refreshProducts();
              },
              child: CustomScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
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

                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
                      child: CategoryList(
                        categories: state.categories,
                        selectedCategory: state.selectedCategory,
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

                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 28, 20, 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              state.selectedCategory == 'All'
                                  ? 'FEATURED PRODUCTS'
                                  : state.selectedCategory.toUpperCase(),
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

                  if (state.isLoading && allProducts.isEmpty)
                    const SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  else if (state.errorMessage != null &&
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
                                state.errorMessage!,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {
                                  context
                                      .read<ProductsCubit>()
                                      .loadProducts();
                                },
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
                        isFavorites: false,
                        onExplore: () {},
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
                              isFavorite: state.favoriteProductIds
                                  .contains(product.id),
                              onFavoriteTap: () {
                                context
                                    .read<ProductsCubit>()
                                    .toggleFavorite(product.id);
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

                  if (state.isLoadingMore)
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    )
                  else if (state.loadMoreError != null)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                          bottom: 24,
                        ),
                        child: Center(
                          child: TextButton(
                            onPressed: () {
                              context
                                  .read<ProductsCubit>()
                                  .loadMoreProducts();
                            },
                            child: const Text(
                              'Retry loading more products',
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
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