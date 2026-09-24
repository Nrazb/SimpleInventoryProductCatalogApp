import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => message;
}

ApiException mapDioError(DioException e) {
  if (e.type == DioExceptionType.connectionTimeout ||
      e.type == DioExceptionType.receiveTimeout ||
      e.type == DioExceptionType.sendTimeout) {
    return ApiException('Connection timeout. Check your internet.');
  }
  if (e.type == DioExceptionType.connectionError) {
    return ApiException('No internet connection.');
  }
  if (e.response != null) {
    final status = e.response!.statusCode;
    final data = e.response!.data;
    String msg = 'Request failed ($status)';
    if (data is Map && data['message'] != null) {
      msg = data['message'].toString();
    }
    return ApiException(msg);
  }
  return ApiException('Something went wrong: ${e.message}');
}
