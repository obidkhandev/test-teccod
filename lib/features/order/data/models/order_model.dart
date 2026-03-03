class OrderModel {
  final int orderId;
  final String status;
  final String? paymentUrl;

  const OrderModel({
    required this.orderId,
    required this.status,
    this.paymentUrl,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      orderId: json['order_id'] as int,
      status: json['status'] as String,
      paymentUrl: json['payment_url'] as String?,
    );
  }
}
