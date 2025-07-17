import 'package:clean_architecture_with_bloc/core/utils/logger.dart';
import 'package:dio/dio.dart';

class ApiService {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'https://jsonplaceholder.typicode.com/',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  )..interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) {
      // You can add headers or logging here
      appLog("[Request] => ${options.method} ${options.path}");
      return handler.next(options);
    },
    onResponse: (response, handler) {
      // Success logs
      appLog("[Response] => ${response.statusCode} ${response.data}");
      return handler.next(response);
    },
    onError: (DioException e, handler) {
      // Log errors globally
      appLog("[DioError] => ${e.type}: ${e.message}");
      return handler.next(e);
    },
  ));
}
