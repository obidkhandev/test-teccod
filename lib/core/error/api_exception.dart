/// Base custom exception for all API errors
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  const ApiException(this.message, {this.statusCode});

  @override
  String toString() => 'ApiException($statusCode): $message';
}

/// Network connectivity error (no internet)
class NetworkException extends ApiException {
  const NetworkException(super.message) : super(statusCode: null);
}

/// Server returned 4xx or 5xx
class ServerException extends ApiException {
  const ServerException(super.message, {super.statusCode});
}

/// Request timed out
class TimeoutException extends ApiException {
  const TimeoutException(super.message) : super(statusCode: null);
}
