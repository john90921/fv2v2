import 'package:flutter/foundation.dart';
import 'package:fv2/services/HmsPushService.dart';
import 'package:fv2/services/PushNotificationApiService.dart';

class HmsPushProvider extends ChangeNotifier {
  final HmsPushService _hmsPushService = HmsPushService();
  String? _pushToken;
  bool _isInitialized = false;
  
  String? get pushToken => _pushToken;
  bool get isInitialized => _isInitialized;
  
  /// Initialize HMS Push and setup callbacks
  Future<void> initialize() async {
    if (_isInitialized) {
      print('HMS Push already initialized');
      return;
    }
    
    print('Initializing HMS Push...');
    
    // Setup callbacks
    _hmsPushService.setOnTokenReceived((token) async {
      print('Push token received: $token');
      _pushToken = token;
      notifyListeners();
      
      // Register token with backend
      await _registerTokenWithBackend(token);
    });
    
    _hmsPushService.setOnMessageReceived((message) {
      print('Push message received: $message');
      _handlePushMessage(message);
    });
    
    // Get initial token
    final token = await _hmsPushService.getToken();
    if (token != null) {
      _pushToken = token;
      notifyListeners();
      
      // Register token with backend
      await _registerTokenWithBackend(token);
    }
    
    _isInitialized = true;
    notifyListeners();
    
    print('HMS Push initialized successfully');
  }
  
  /// Register push token with backend
  Future<void> _registerTokenWithBackend(String token) async {
    try {
      final success = await PushNotificationApiService.registerPushToken(token);
      if (success) {
        print('Push token registered with backend successfully');
      } else {
        print('Failed to register push token with backend');
      }
    } catch (e) {
      print('Error registering push token: $e');
    }
  }
  
  /// Handle incoming push messages
  void _handlePushMessage(Map<String, dynamic> message) {
    // You can customize this to navigate to specific screens or show notifications
    print('Handling push message: $message');
    
    // Example: if it's a comment notification, you might want to navigate to the post
    final data = message['data'];
    if (data != null && data is Map) {
      final type = data['type'];
      if (type == 'comment') {
        // Handle comment notification
        print('Comment notification received');
      }
    }
  }
  
  /// Refresh push token
  Future<void> refreshToken() async {
    final token = await _hmsPushService.getToken();
    if (token != null) {
      _pushToken = token;
      notifyListeners();
      await _registerTokenWithBackend(token);
    }
  }
  
  /// Unregister push token
  Future<void> unregister() async {
    try {
      await PushNotificationApiService.unregisterPushToken();
      await _hmsPushService.deleteToken();
      _pushToken = null;
      notifyListeners();
      print('Push token unregistered successfully');
    } catch (e) {
      print('Error unregistering push token: $e');
    }
  }
  
  @override
  void dispose() {
    _hmsPushService.dispose();
    super.dispose();
  }
}

