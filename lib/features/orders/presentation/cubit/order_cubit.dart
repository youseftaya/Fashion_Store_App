import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/order.dart';
import '../../domain/usecases/cancel_order.dart';
import '../../domain/usecases/get_order_by_id.dart';
import '../../domain/usecases/get_orders.dart';
import '../../domain/usecases/place_order.dart';
import 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  final GetOrders getOrders;
  final PlaceOrder placeOrder;
  final CancelOrder cancelOrder;
  final GetOrderById getOrderById;

  OrderCubit({
    required this.getOrders,
    required this.placeOrder,
    required this.cancelOrder,
    required this.getOrderById,
  }) : super(const OrderState());

  Future<void> loadOrders() async {
    emit(state.copyWith(
      status: OrderStatus.loading,
      clearError: true,
    ));

    try {
      final orders = await getOrders();

      emit(state.copyWith(
        status: OrderStatus.success,
        orders: orders,
        clearError: true,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: OrderStatus.failure,
        errorMessage: error.toString(),
      ));
    }
  }

  Future<Order?> createOrder({
    required String customerName,
    required String email,
    required String phone,
    required String address,
    required List<OrderItem> items,
    required double totalPrice,
  }) async {
    emit(state.copyWith(
      status: OrderStatus.loading,
      clearError: true,
    ));

    try {
      final order = await placeOrder(
        customerName: customerName,
        email: email,
        phone: phone,
        address: address,
        items: items,
        totalPrice: totalPrice,
      );

      final updatedOrders = await getOrders();

      emit(state.copyWith(
        status: OrderStatus.success,
        orders: updatedOrders,
        clearError: true,
      ));

      return order;
    } catch (error) {
      emit(state.copyWith(
        status: OrderStatus.failure,
        errorMessage: error.toString(),
      ));

      return null;
    }
  }

  Future<bool> cancelOrderById(String orderId) async {
    emit(state.copyWith(
      status: OrderStatus.loading,
      clearError: true,
    ));

    try {
      final cancelled = await cancelOrder(orderId);

      if (!cancelled) {
        emit(state.copyWith(
          status: OrderStatus.success,
          clearError: true,
        ));
        return false;
      }

      final updatedOrders = await getOrders();

      emit(state.copyWith(
        status: OrderStatus.success,
        orders: updatedOrders,
        clearError: true,
      ));

      return true;
    } catch (error) {
      emit(state.copyWith(
        status: OrderStatus.failure,
        errorMessage: error.toString(),
      ));

      return false;
    }
  }

  Future<Order?> fetchOrderById(String id) async {
    try {
      return await getOrderById(id);
    } catch (error) {
      emit(state.copyWith(
        status: OrderStatus.failure,
        errorMessage: error.toString(),
      ));

      return null;
    }
  }
}