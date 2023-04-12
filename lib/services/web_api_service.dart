import 'dart:io';
import 'package:dio/dio.dart';
import 'package:ticket_checker/config/app_config.dart';
import '_base.dart';
import '_mixin_api.dart';

class WebAPIService extends BaseService with WebAPIMixin {
  // static final WebAPIService _instance = WebAPIService._initialise();

  WebAPIService._initialise()
      : _dio = Dio(
            BaseOptions(connectTimeout: 50000, receiveTimeout: 30000, headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        })) {
    if (AppConfig.isDebugMode) {
      dio.interceptors.add(LogInterceptor(
        responseHeader: false,
        responseBody: true,
        requestBody: true,
        requestHeader: true,
      ));
    }
  }

  factory WebAPIService() => WebAPIService._initialise();

  final Dio _dio;

  Dio get dio => _dio;
}
