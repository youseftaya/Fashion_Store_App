import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

import '../../providers/auth_provider.dart';

import '../../features/cart/presentation/cubit/cart_cubit.dart';
import '../../features/cart/presentation/cubit/cart_state.dart';

import '../../features/orders/domain/entities/order.dart';
import '../../features/orders/presentation/cubit/order_cubit.dart';
import '../../features/orders/presentation/cubit/order_state.dart';

import '../widgets/checkout_section_title.dart';
import '../widgets/checkout_text_field.dart';
import '../widgets/checkout_order_summary.dart';
import '../widgets/checkout_payment_method.dart';
import '../widgets/checkout_place_order_button.dart';

import 'order_success_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _emailController;

  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();

    final user = context.read<AuthProvider>().currentUser;

    _nameController = TextEditingController(
      text: user?.displayName ?? '',
    );

    _emailController = TextEditingController(
      text: user?.email ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _placeOrder() async {
    if (!_formKey.currentState!.validate()) return;

    final cartCubit = context.read<CartCubit>();
    final orderCubit = context.read<OrderCubit>();

    final items = cartCubit.state.items;
    final total = cartCubit.state.totalPrice;

    if (items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Your cart is empty.'),
        ),
      );
      return;
    }

    final orderItems = items.map((item) {
      return OrderItem(
        productId: item.product.id,
        productName: item.product.name,
        productImage: item.product.imageUrl,
        price: item.product.price,
        size: item.size,
        color: item.color,
        quantity: item.quantity,
      );
    }).toList();

    final order = await orderCubit.createOrder(
      customerName: _nameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      address: _addressController.text,
      items: orderItems,
      totalPrice: total,
    );

    if (!mounted) return;

    if (order == null) {
      final error = orderCubit.state.errorMessage ??
          'Something went wrong. Please try again.';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to place order: $error'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    await cartCubit.clearCartItems();

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => OrderSuccessScreen(
          orderId: order.id,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, cartState) {
        final items = cartState.items;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.background,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: AppColors.primary,
                size: 20,
              ),
            ),
            title: Text(
              'CHECKOUT',
              style: AppTextStyles.sectionTitle.copyWith(
                fontSize: 15,
                letterSpacing: 1.5,
              ),
            ),
          ),
          body: items.isEmpty
              ? const Center(
                  child: Text('Your cart is empty.'),
                )
              : Form(
                  key: _formKey,
                  child: ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      const CheckoutSectionTitle(
                        title: 'DELIVERY INFORMATION',
                      ),
                      const SizedBox(height: 16),

                      CheckoutTextField(
                        controller: _nameController,
                        label: 'Full Name',
                        icon: Icons.person_outline,
                      ),
                      const SizedBox(height: 14),

                      CheckoutTextField(
                        controller: _emailController,
                        label: 'Email Address',
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 14),

                      CheckoutTextField(
                        controller: _phoneController,
                        label: 'Phone Number',
                        icon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 14),

                      CheckoutTextField(
                        controller: _addressController,
                        label: 'Delivery Address',
                        icon: Icons.location_on_outlined,
                        maxLines: 3,
                      ),

                      const SizedBox(height: 30),

                      const CheckoutSectionTitle(
                        title: 'ORDER SUMMARY',
                      ),
                      const SizedBox(height: 16),

                      CheckoutOrderSummary(
                        items: items,
                        totalPrice: cartState.totalPrice,
                      ),

                      const SizedBox(height: 30),

                      const CheckoutSectionTitle(
                        title: 'PAYMENT METHOD',
                      ),
                      const SizedBox(height: 14),

                      const CheckoutPaymentMethod(),

                      const SizedBox(height: 30),

                      BlocBuilder<OrderCubit, OrderState>(
                        builder: (context, state) {
                          return CheckoutPlaceOrderButton(
                            isLoading: state.isLoading,
                            onPressed: state.isLoading
                                ? null
                                : _placeOrder,
                          );
                        },
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
        );
      },
    );
  }
}