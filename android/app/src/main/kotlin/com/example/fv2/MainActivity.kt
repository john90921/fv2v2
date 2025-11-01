package com.example.fv2

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.content.Context
import android.util.Log
import com.huawei.hms.aaid.HmsInstanceId
import com.huawei.hms.common.ApiException

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.fv2/hms_push"
    private val TAG = "MainActivity"
    
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        val methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        
        // Set the method channel in HmsPushService so it can send messages to Flutter
        HmsPushService.methodChannel = methodChannel
        
        methodChannel.setMethodCallHandler { call, result ->
            when (call.method) {
                "getToken" -> {
                    try {
                        // Get token in a background thread
                        Thread {
                            try {
                                val appId = "115740549"
                                val token = HmsInstanceId.getInstance(this).getToken(appId, "HCM")
                                
                                // Save token to SharedPreferences
                                val sharedPref = getSharedPreferences("HMS_PREFS", Context.MODE_PRIVATE)
                                with(sharedPref.edit()) {
                                    putString("push_token", token)
                                    apply()
                                }
                                
                                runOnUiThread {
                                    if (!token.isNullOrEmpty()) {
                                        Log.i(TAG, "Get token: $token")
                                        result.success(token)
                                    } else {
                                        result.error("TOKEN_ERROR", "Token is empty", null)
                                    }
                                }
                            } catch (e: ApiException) {
                                Log.e(TAG, "Get token failed: ${e.message}")
                                runOnUiThread {
                                    result.error("API_EXCEPTION", e.message, null)
                                }
                            }
                        }.start()
                    } catch (e: Exception) {
                        Log.e(TAG, "Error: ${e.message}")
                        result.error("ERROR", e.message, null)
                    }
                }
                "deleteToken" -> {
                    try {
                        Thread {
                            try {
                                val appId = "115740549"
                                HmsInstanceId.getInstance(this).deleteToken(appId, "HCM")
                                
                                // Clear token from SharedPreferences
                                val sharedPref = getSharedPreferences("HMS_PREFS", Context.MODE_PRIVATE)
                                with(sharedPref.edit()) {
                                    remove("push_token")
                                    apply()
                                }
                                
                                runOnUiThread {
                                    result.success(true)
                                }
                            } catch (e: ApiException) {
                                Log.e(TAG, "Delete token failed: ${e.message}")
                                runOnUiThread {
                                    result.error("API_EXCEPTION", e.message, null)
                                }
                            }
                        }.start()
                    } catch (e: Exception) {
                        result.error("ERROR", e.message, null)
                    }
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
}
