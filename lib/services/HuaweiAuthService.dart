import 'package:flutter/services.dart';
import 'package:huawei_account/huawei_account.dart';

class HuaweiAuthService {
  static final HuaweiAuthService _instance = HuaweiAuthService._internal();
  
  factory HuaweiAuthService() {
    return _instance;
  }
  
  HuaweiAuthService._internal();
  
  /// Sign in with Huawei ID
  Future<Map<String, dynamic>?> signIn() async {
    try {
      // Create auth params
      final AccountAuthParamsHelper authParamsHelper = AccountAuthParamsHelper()
        ..setIdToken()
        ..setAccessToken()
        ..setProfile()
        ..setEmail()
        ..setId();
      
      final AccountAuthParams authParams = authParamsHelper.createParams();
      final AccountAuthService authService = AccountAuthManager.getService(authParams);
      
      // Sign in
      final AuthAccount result = await authService.signIn();
      
      // Return user information
      return {
        'displayName': result.displayName ?? '',
        'email': result.email ?? '',
        'idToken': result.idToken ?? '',
        'accessToken': result.accessToken ?? '',
        'openId': result.openId ?? '',
        'unionId': result.unionId ?? '',
        'avatarUri': result.avatarUri ?? '',
      };
    } on PlatformException catch (e) {
      print('Huawei Sign In Error: ${e.code} - ${e.message}');
      throw Exception('Sign in failed: ${e.message}');
    } catch (e) {
      print('Unexpected error during sign in: $e');
      throw Exception('Sign in failed: $e');
    }
  }
  
  /// Sign out from Huawei ID
  Future<void> signOut() async {
    try {
      final AccountAuthParamsHelper authParamsHelper = AccountAuthParamsHelper();
      final AccountAuthParams authParams = authParamsHelper.createParams();
      final AccountAuthService authService = AccountAuthManager.getService(authParams);
      
      await authService.signOut();
      print('Huawei sign out successful');
    } on PlatformException catch (e) {
      print('Huawei Sign Out Error: ${e.code} - ${e.message}');
      throw Exception('Sign out failed: ${e.message}');
    } catch (e) {
      print('Unexpected error during sign out: $e');
      throw Exception('Sign out failed: $e');
    }
  }
  
  /// Cancel authorization (revoke access)
  Future<void> cancelAuthorization() async {
    try {
      final AccountAuthParamsHelper authParamsHelper = AccountAuthParamsHelper();
      final AccountAuthParams authParams = authParamsHelper.createParams();
      final AccountAuthService authService = AccountAuthManager.getService(authParams);
      
      await authService.cancelAuthorization();
      print('Huawei authorization cancelled');
    } on PlatformException catch (e) {
      print('Huawei Cancel Authorization Error: ${e.code} - ${e.message}');
      throw Exception('Cancel authorization failed: ${e.message}');
    } catch (e) {
      print('Unexpected error during cancel authorization: $e');
      throw Exception('Cancel authorization failed: $e');
    }
  }
  
  /// Silent sign in (get cached account)
  Future<Map<String, dynamic>?> silentSignIn() async {
    try {
      final AccountAuthParamsHelper authParamsHelper = AccountAuthParamsHelper()
        ..setIdToken()
        ..setAccessToken()
        ..setProfile()
        ..setEmail()
        ..setId();
      
      final AccountAuthParams authParams = authParamsHelper.createParams();
      final AccountAuthService authService = AccountAuthManager.getService(authParams);
      
      final AuthAccount result = await authService.silentSignIn();
      
      return {
        'displayName': result.displayName ?? '',
        'email': result.email ?? '',
        'idToken': result.idToken ?? '',
        'accessToken': result.accessToken ?? '',
        'openId': result.openId ?? '',
        'unionId': result.unionId ?? '',
        'avatarUri': result.avatarUri ?? '',
      };
    } on PlatformException catch (e) {
      print('Huawei Silent Sign In Error: ${e.code} - ${e.message}');
      return null;
    } catch (e) {
      print('Unexpected error during silent sign in: $e');
      return null;
    }
  }
}
