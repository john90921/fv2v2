import 'package:dio/dio.dart';
import 'package:fv2/dio/DioHandler.dart';

class ApiResult{
  final bool status;
  final String message;
  dynamic data;

  ApiResult({
    required this.status,
    required this.message,
    this.data
  });
}

class ApiRequest{
  final String path;
  dynamic data;


  ApiRequest({
    required this.path,
    this.data
  });
}
class Apihelper {

  static Future<ApiResult> post(ApiRequest apiRequest) async{
     Dio _dio = DioHandler.instance.dio;
    try{
        final response = await _dio.post(apiRequest.path, data: apiRequest.data);
        final data = response.data;
        return ApiResult(status:data["status"], message: data["message"],data: data["data"]);
      }
      on DioException catch(e){
        String? message;
      //   if(e.response != null){
      //     final status = e.response?.statusCode ?? 0;
      //     final data = e.response?.data;
      //      if (status == 422) {
      //   // ✅ Validation error
      //   final errors = data['errors'] as Map<String, dynamic>?;
      //   final firstError = errors?.values.first[0] ?? 'Invalid input';
      //   message = firstError;
      // }
      //  if (status == 403) {
      //   message = 'Forbidden: You do not have permission.';
      // } else if (status == 404) {
      //   message = 'Not Found: API endpoint missing.';
      // } else if (status == 500) {
      //   message = 'Server error. Please try again later.';
      // } else {
      //   message = 'Error ${status}: ${data['message'] ?? 'Unknown error'}';
      // }
      //   }
       if (e.response != null && e.response?.statusCode == 422) {
        final errors = e.response?.data['errors'];
        final firstError = errors.values.first[0];
        return ApiResult(status: false, message: firstError, data: null);
      }
      return ApiResult(status: false, message: e.message ?? "Network error", data: null);
      }
  }
  static Future<ApiResult> get(ApiRequest apiRequest) async{
     Dio _dio = DioHandler.instance.dio;
      try{
        final response = await _dio.get(apiRequest.path, queryParameters: apiRequest.data);
        final data = response.data;
        return ApiResult(status:data["status"], message: data["message"],data: data["data"]); 
      }
      on DioException catch(e){
       if (e.response != null && e.response?.statusCode == 422) {
        final errors = e.response?.data['errors'];
        final firstError = errors.values.first[0];
        return ApiResult(status: false, message: firstError, data: null);
      }
      return ApiResult(status: false, message: e.message ?? "Network error", data: null);
      }
  }
   static Future<ApiResult> delete(ApiRequest apiRequest) async{
     Dio _dio = DioHandler.instance.dio;
      try{
        final response = await _dio.delete(apiRequest.path);
        final data = response.data;
        return ApiResult(status:data["status"], message: data["message"],data: data["data"]); 
      }
      on DioException catch(e){
       if (e.response != null && e.response?.statusCode == 422) {
        final errors = e.response?.data['errors'];
        final firstError = errors.values.first[0];
        return ApiResult(status: false, message: firstError, data: null);
      }
      return ApiResult(status: false, message: e.message ?? "Network error", data: null);
      }
  }

   static Future<ApiResult> patch(ApiRequest apiRequest)async{
    Dio _dio = DioHandler.instance.dio;
    try{
      final Response response;
      
      
    if (apiRequest.data is FormData) {
      response = await _dio.post(
        apiRequest.path,
        data: apiRequest.data,
      );
    } else {
      response = await _dio.patch(
        apiRequest.path,
        data: apiRequest.data,
      );
    }
      final data = response.data;
      print("API PATCH Response: $data");
      return ApiResult(status:data["status"], message: data["message"],data: data["data"]);
    }
    on DioException catch(e){
      if (e.response != null && e.response?.statusCode == 422) {
        final errors = e.response?.data['errors'];
        final firstError = errors.values.first[0];
        return ApiResult(status: false, message: firstError, data: null);
      }
      return ApiResult(status: false, message: e.message ?? "Network error", data: null);
    }
   }

}
