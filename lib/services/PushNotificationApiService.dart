import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:fv2/api/ApiHelper.dart';

class PushNotificationApiService {
  static const String HMS_API_URL = 'https://push-api.cloud.huawei.com';
  static const String CLIENT_ID = '115740549';
  static const String CLIENT_SECRET = '24a731d281cd7a210db0372ebeec8020edcfa0930ddb667764a7c93998450571';
  
  // Cache for access token
  static String? _accessToken;
  static DateTime? _tokenExpiry;
  
  /// Get OAuth 2.0 access token from Huawei
  static Future<String?> _getAccessToken() async {
    // Return cached token if still valid
    if (_accessToken != null && _tokenExpiry != null && DateTime.now().isBefore(_tokenExpiry!)) {
      return _accessToken;
    }
    
    try {
      final dio = Dio();
      final response = await dio.post(
        'https://oauth-login.cloud.huawei.com/oauth2/v3/token',
        data: {
          'grant_type': 'client_credentials',
          'client_id': CLIENT_ID,
          'client_secret': CLIENT_SECRET,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        ),
      );
      
      if (response.statusCode == 200) {
        final data = response.data;
        _accessToken = data['access_token'];
        final expiresIn = data['expires_in'] as int;
        _tokenExpiry = DateTime.now().add(Duration(seconds: expiresIn - 60)); // Subtract 60s for safety
        
        print('Access token obtained successfully');
        return _accessToken;
      } else {
        print('Failed to get access token: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error getting access token: $e');
      return null;
    }
  }
  
  /// Send push notification to a specific device token
  static Future<bool> sendNotificationToToken({
    required String pushToken,
    required String title,
    required String body,
    Map<String, String>? data,
  }) async {
    try {
      final accessToken = await _getAccessToken();
      if (accessToken == null) {
        print('Failed to get access token');
        return false;
      }
      
      final dio = Dio();
      final response = await dio.post(
        '$HMS_API_URL/v1/$CLIENT_ID/messages:send',
        data: jsonEncode({
          'validate_only': false,
          'message': {
            'notification': {
              'title': title,
              'body': body,
            },
            'android': {
              'notification': {
                'click_action': {
                  'type': 3, // Open app
                },
              },
            },
            'data': data != null ? jsonEncode(data) : null,
            'token': [pushToken],
          },
        }),
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          },
        ),
      );
      
      if (response.statusCode == 200) {
        print('Notification sent successfully');
        return true;
      } else {
        print('Failed to send notification: ${response.statusCode}');
        print('Response: ${response.data}');
        return false;
      }
    } catch (e) {
      print('Error sending notification: $e');
      return false;
    }
  }
  
  /// Send notification via backend API (recommended approach)
  /// This should be called from the backend when a comment is created
  static Future<bool> sendCommentNotification({
    required int postId,
    required int commentId,
    required String commenterName,
    required String commentContent,
  }) async {
    try {
      ApiResult result = await Apihelper.post(
        ApiRequest(
          path: "/notifications/comment",
          data: {
            "post_id": postId,
            "comment_id": commentId,
            "commenter_name": commenterName,
            "comment_content": commentContent,
          },
        ),
      );
      
      if (result.status == true) {
        print('Comment notification sent successfully');
        return true;
      } else {
        print('Failed to send comment notification: ${result.message}');
        return false;
      }
    } catch (e) {
      print('Error sending comment notification: $e');
      return false;
    }
  }
  
  /// Register device token with backend
  static Future<bool> registerPushToken(String pushToken) async {
    try {
      ApiResult result = await Apihelper.post(
        ApiRequest(
          path: "/users/register-push-token",
          data: {
            "push_token": pushToken,
            "platform": "huawei",
          },
        ),
      );
      
      if (result.status == true) {
        print('Push token registered successfully');
        return true;
      } else {
        print('Failed to register push token: ${result.message}');
        return false;
      }
    } catch (e) {
      print('Error registering push token: $e');
      return false;
    }
  }
  
  /// Unregister device token from backend
  static Future<bool> unregisterPushToken() async {
    try {
      ApiResult result = await Apihelper.delete(
        ApiRequest(path: "/users/unregister-push-token"),
      );
      
      if (result.status == true) {
        print('Push token unregistered successfully');
        return true;
      } else {
        print('Failed to unregister push token: ${result.message}');
        return false;
      }
    } catch (e) {
      print('Error unregistering push token: $e');
      return false;
    }
  }
}

