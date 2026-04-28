import 'package:dio/dio.dart';
import 'package:ts_training_demo_fb/core/network/interceptor/app_interceptor.dart';

class AppDio {
  static Dio dio=Dio(
    BaseOptions(
      baseUrl: '',
      connectTimeout: Duration(seconds: 5),
      receiveTimeout: Duration(seconds: 5),
      headers:{
        "Content-type" : "application/json",
      }
    ),
  );
}