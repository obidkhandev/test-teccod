import 'package:test_teccod/features/order/data/models/order_model.dart';

abstract class IOrderRepository {
  Future<OrderModel> createOrder({required int userId, required int serviceId});
}
