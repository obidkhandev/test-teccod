import 'package:test_teccod/features/order/data/datasources/order_datasource.dart';
import 'package:test_teccod/features/order/data/models/order_model.dart';
import 'package:test_teccod/features/order/domain/repositories/order_repository.dart';

class OrderRepositoryImpl implements IOrderRepository {
  final OrderDatasource _datasource;

  OrderRepositoryImpl(this._datasource);

  @override
  Future<OrderModel> createOrder({
    required int userId,
    required int serviceId,
  }) {
    return _datasource.createOrder(userId: userId, serviceId: serviceId);
  }
}
