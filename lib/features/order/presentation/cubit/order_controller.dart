import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_teccod/core/error/api_exception.dart';
import 'package:test_teccod/core/utils/enums.dart';
import 'package:test_teccod/features/order/domain/usecases/create_order_usecase.dart';
import 'package:test_teccod/features/order/presentation/cubit/order_state.dart';

class OrderController extends Cubit<OrderState> {
  final CreateOrderUseCase _createOrderUseCase;

  OrderController(this._createOrderUseCase) : super(const OrderState());

  Future<void> submitOrder({
    required int userId,
    required int serviceId,
  }) async {
    emit(state.copyWith(status: OrderStatus.loading));

    try {
      final order = await _createOrderUseCase(
        userId: userId,
        serviceId: serviceId,
      );

      emit(state.copyWith(
        status: OrderStatus.success,
        order: order,
      ));
    } on ApiException catch (e) {
      emit(state.copyWith(
        status: OrderStatus.error,
        errorMessage: e.message,
      ));
    }
  }
}
