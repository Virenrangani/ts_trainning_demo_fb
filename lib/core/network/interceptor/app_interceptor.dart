import 'package:dio/dio.dart';

class AppInterceptor extends Interceptor{
  final Dio dio;
  AppInterceptor({required this.dio});

  @override
  void onRequest(
      RequestOptions options,
      RequestInterceptorHandler handler,
      ) {
    print("Request :${options.path}");
    print("Request :${options.method}");
    handler.next(options);
  }




}