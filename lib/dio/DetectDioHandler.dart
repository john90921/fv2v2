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
class DetectDioHandler {
  final Dio dio;
  
  
  DetectDioHandler._internal()
      : dio = Dio(BaseOptions(
          baseUrl: "https://shunda012-plant-disease-fastapi.hf.space/predict", // change to your API
          connectTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 5),
           headers: {
            "Accept": "application/json",
          },
        )) {
    // Add interceptor to attach token
  }

  // Singleton instance
  static final DetectDioHandler _instance = DetectDioHandler._internal();
  static DetectDioHandler get instance => _instance;
}
