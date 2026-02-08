import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ecommerce_customer/SERVICES/flutterSecureStorage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'dio_mobile_adapter.dart' if (dart.library.html) 'dio_web_adapter.dart';

class Dioclient {
  static late final Dio dio;
  static void init() {
    String clientType = "mobile";
    if (kIsWeb) {
      clientType = "web";
    }
    BaseOptions options = BaseOptions(
      baseUrl: dotenv.env['API_URL']!,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'x-client-type': clientType,
        'X-Requested-With': 'XMLHttpRequest',
      },
      validateStatus: (status) {
        return status != null && status < 500;
      },
    );
    dio = Dio(options);
    dio.httpClientAdapter = getAdapter();
    if (!kIsWeb) {
      (dio.httpClientAdapter as dynamic).createHttpClient = () {
        final client = HttpClient();
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        return client;
      };
      dio.interceptors.add(AuthInterceptor());
    }

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // 🔥 All requests go through here
          debugPrint('➡️ ${options.method} ${options.uri}');
          handler.next(options);
        },
        onResponse: (response, handler) {
          debugPrint('✅ ${response.statusCode} ${response.requestOptions.uri}');
          handler.next(response);
        },
        onError: (DioException e, handler) {
          debugPrint('❌ ${e.response?.statusCode} ${e.requestOptions.uri}');

          // 🔐 Auto redirect on auth failure
          if (e.response?.statusCode == 401) {
            debugPrint('❌401 un Authorised');
          }

          handler.next(e);
        },
      ),
    );
  }
}

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await SecureStorage.instance.getToken();

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    super.onRequest(options, handler);
  }
}
