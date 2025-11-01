import 'package:flutter/services.dart';
import 'dart:async';

class HmsPushService {
  static const MethodChannel _channel = MethodChannel('com.example.fv2/hms_push');
  
  // Callbacks
  static Function(String)? _onTokenReceived;
  static Function(Map<String, dynamic>)? _onMessageReceived;
  
  // Singleton pattern
  static final HmsPushService _instance = HmsPushService._internal();
  
  factory HmsPushService() {
    return _instance;
  }
  
  HmsPushService._internal() {
    _setupMethodCallHandler();
  }
  
  void _setupMethodCallHandler() {
    _channel.setMethodCallHandler((call) async {
      switch (call.method) {
        case 'onNewToken':
          final String token = call.arguments as String;
          print('HMS Push Token: $token');
          if (_onTokenReceived != null) {
            _onTokenReceived!(token);
          }
          break;
        case 'onMessageReceived':
          final Map<String, dynamic> message = Map<String, dynamic>.from(call.arguments);
          print('Message received: $message');
          if (_onMessageReceived != null) {
            _onMessageReceived!(message);
          }
          break;
      }
    });
  }
  
  /// Initialize HMS Push and get token
  Future<String?> getToken() async {
    try {
      final String? token = await _channel.invokeMethod('getToken');
      print('HMS Push Token retrieved: $token');
      return token;
    } on PlatformException catch (e) {
      print('Error getting token: ${e.message}');
      return null;
    }
  }
  
  /// Delete HMS Push token
  Future<bool> deleteToken() async {
    try {
      final bool? result = await _channel.invokeMethod('deleteToken');
      return result ?? false;
    } on PlatformException catch (e) {
      print('Error deleting token: ${e.message}');
      return false;
    }
  }
  
  /// Set callback for when token is received
  void setOnTokenReceived(Function(String) callback) {
    _onTokenReceived = callback;
  }
  
  /// Set callback for when message is received
  void setOnMessageReceived(Function(Map<String, dynamic>) callback) {
    _onMessageReceived = callback;
  }
  
  /// Remove callbacks
  void dispose() {
    _onTokenReceived = null;
    _onMessageReceived = null;
  }
}

