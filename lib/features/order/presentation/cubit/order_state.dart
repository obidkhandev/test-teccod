import 'package:equatable/equatable.dart';
import 'package:test_teccod/core/utils/enums.dart';
import 'package:test_teccod/features/order/data/models/order_model.dart';

class OrderState extends Equatable {
  final OrderStatus status;
  final OrderModel? order;
  final String? errorMessage;

  const OrderState({
    this.status = OrderStatus.initial,
    this.order,
    this.errorMessage,
  });

  OrderState copyWith({
    OrderStatus? status,
    OrderModel? order,
    String? errorMessage,
  }) {
    return OrderState(
      status: status ?? this.status,
      order: order ?? this.order,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, order, errorMessage];
}
