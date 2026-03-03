import 'package:test_teccod/features/order/data/models/order_model.dart';
import 'package:test_teccod/features/order/domain/repositories/order_repository.dart';

class CreateOrderUseCase {
  final IOrderRepository _repository;

  CreateOrderUseCase(this._repository);

  Future<OrderModel> call({required int userId, required int serviceId}) {
    return _repository.createOrder(userId: userId, serviceId: serviceId);
  }
}
