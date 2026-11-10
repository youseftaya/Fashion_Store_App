import '../../features/orders/data/datasources/order_local_data_source.dart';
import '../../features/orders/data/repositories/order_repository_impl.dart';
import '../../features/orders/domain/repositories/order_repository.dart';
import '../../features/orders/domain/usecases/cancel_order.dart';
import '../../features/orders/domain/usecases/get_order_by_id.dart';
import '../../features/orders/domain/usecases/get_orders.dart';
import '../../features/orders/domain/usecases/place_order.dart';
import '../../features/orders/presentation/cubit/order_cubit.dart';

OrderCubit createOrderCubit() {
  final OrderLocalDataSource localDataSource =
      OrderLocalDataSourceImpl();

  final OrderRepository repository = OrderRepositoryImpl(
    localDataSource: localDataSource,
  );

  return OrderCubit(
    getOrders: GetOrders(repository),
    placeOrder: PlaceOrder(repository),
    cancelOrder: CancelOrder(repository),
    getOrderById: GetOrderById(repository),
  );
}