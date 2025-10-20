// import 'package:dio/dio.dart';

// class DioClient {
//   final Dio dio = Dio(
//     BaseOptions(
//       baseUrl: "http://127.0.0.1:8000/api", // your API base URL
//       connectTimeout: const Duration(seconds: 5),
//       receiveTimeout: const Duration(seconds: 5),
//       headers: {
//         "Accept": "application/json", // 👈 important for Laravel API
//       },
//     ),
//   );
// }

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fv2/main.dart';
import 'package:fv2/token/TokenManager.dart';

class DioHandler {
  final Dio dio;

  DioHandler._internal()
      : dio = Dio(BaseOptions(
          baseUrl: "http://192.168.56.1:8000/api/v1", // change to your API
          connectTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 5),
        )) {
    // Add interceptor to attach token
    dio.interceptors.add(
      InterceptorsWrapper(
      onRequest: (options, handler) async {
        String? token = TokenManager.instance.accessToken;

        // If token not in memory, try loading from storage
        if (token == null) {
          await TokenManager.instance.loadAccessToken();
          token = TokenManager.instance.accessToken;
        }
        // Attach Authorization header if token exists
        if (token != null) {
          options.headers['Authorization'] = 'Bearer 47|QDmd999QtqR55zoqu0cb9D2pPKUCkGmTSMejHmQo11100a0a';
        }
        // options.headers['Authorization'] = 'Bearer 1|lPTgCt5iF6fBpSRk0pxa48nTZh48IZi4bFodWijS97ee52b7';

// 37|AJBFI5UPdgBnduAc6PUaYuu276UanKGbEt6xjqA2f712b8ee
        return handler.next(options);
      },
      onError: (err, handler) {
        if (err.response?.statusCode == 401) {
          // Token invalid or expired
          TokenManager.instance.clearAccessToken();
            ScaffoldMessenger.of(
            navigatorKey.currentState!.context,
          ).showSnackBar(
            const SnackBar(content: Text('Session expired. Please log in again.')),
          );
          // Redirect to login page
           navigatorKey.currentState?.pushNamedAndRemoveUntil(
          '/login',
          (route) => false, // removes all previous routes
        );
        }
        return handler.next(err);
      },
    )
    
    );
  }

  // Singleton instance
  static final DioHandler _instance = DioHandler._internal();
  static DioHandler get instance => _instance;
}
