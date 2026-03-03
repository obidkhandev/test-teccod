import 'package:dio/dio.dart';
import 'package:test_teccod/core/api/dio_client.dart';
import 'package:test_teccod/core/api/list_api.dart';
import 'package:test_teccod/core/error/api_exception.dart';
import 'package:test_teccod/features/order/data/models/order_model.dart';

abstract class OrderDatasource {
  Future<OrderModel> createOrder({required int userId, required int serviceId});
}

class OrderDatasourceImpl implements OrderDatasource {
  final DioClient _dioClient;

  OrderDatasourceImpl(this._dioClient);

  @override
  Future<OrderModel> createOrder({
    required int userId,
    required int serviceId,
  }) async {
    try {
      final response = await _dioClient.dio.post(
        ListAPI.orders,
        data: {
          'userId': userId,
          'serviceId': serviceId,
        },
        options: Options(
          receiveTimeout: const Duration(seconds: 10),
          sendTimeout: const Duration(seconds: 10),
        ),
      );

      if (response.statusCode == 200) {
        return OrderModel.fromJson(response.data as Map<String, dynamic>);
      }

      throw ServerException(
        _extractMessage(response.data) ?? 'Unexpected response',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  ApiException _mapDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const TimeoutException('Request timed out. Please try again.');

      case DioExceptionType.connectionError:
        return const NetworkException('No internet connection.');

      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode ?? 0;
        final message = _extractMessage(e.response?.data) ?? 'Server error';
        if (statusCode >= 400) {
          return ServerException(message, statusCode: statusCode);
        }
        return ApiException(message, statusCode: statusCode);

      default:
        if (e.message?.contains('connection') == true ||
            e.message?.contains('network') == true) {
          return const NetworkException('No internet connection.');
        }
        return ApiException(e.message ?? 'Unknown error occurred');
    }
  }

  String? _extractMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      return (data['message'] ?? data['error'] ?? data['detail'])?.toString();
    }
    if (data is String && data.isNotEmpty) return data;
    return null;
  }
}
