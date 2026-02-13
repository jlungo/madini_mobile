import 'package:dio/dio.dart';

import '../../services/storage_service.dart';

/// Basic API interceptor for attaching auth tokens and logging.
class ApiInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await StorageService.instance.readAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Hook for logging or global success handling.
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Central place to inspect status codes, e.g., 401 for logout flows.
    super.onError(err, handler);
  }
}

