package com.example.fv2

import android.content.Intent
import android.os.Bundle
import android.util.Log
import com.huawei.hms.push.HmsMessageService
import com.huawei.hms.push.RemoteMessage
import io.flutter.plugin.common.MethodChannel
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import android.content.Context

class HmsPushService : HmsMessageService() {
    companion object {
        private const val TAG = "HmsPushService"
        const val CHANNEL_NAME = "com.example.fv2/hms_push"
        var methodChannel: MethodChannel? = null
    }

    override fun onNewToken(token: String) {
        super.onNewToken(token)
        Log.i(TAG, "Received new token: $token")
        
        // Send token to Flutter
        methodChannel?.invokeMethod("onNewToken", token)
        
        // You can also save the token to SharedPreferences
        val sharedPref = applicationContext.getSharedPreferences("HMS_PREFS", Context.MODE_PRIVATE)
        with(sharedPref.edit()) {
            putString("push_token", token)
            apply()
        }
    }

    override fun onMessageReceived(remoteMessage: RemoteMessage) {
        super.onMessageReceived(remoteMessage)
        Log.i(TAG, "Message received")
        
        // Extract notification data
        val notification = remoteMessage.notification
        val dataPayload = remoteMessage.dataOfMap
        
        val messageData = HashMap<String, Any?>()
        
        if (notification != null) {
            messageData["title"] = notification.title
            messageData["body"] = notification.body
            messageData["imageUrl"] = notification.imageUrl?.toString()
        }
        
        if (dataPayload != null && dataPayload.isNotEmpty()) {
            messageData["data"] = dataPayload
        }
        
        Log.i(TAG, "Message data: $messageData")
        
        // Send to Flutter
        methodChannel?.invokeMethod("onMessageReceived", messageData)
    }

    override fun onMessageSent(msgId: String) {
        super.onMessageSent(msgId)
        Log.i(TAG, "Message sent: $msgId")
    }

    override fun onSendError(msgId: String, exception: Exception) {
        super.onSendError(msgId, exception)
        Log.e(TAG, "Send error: $msgId, ${exception.message}")
    }

    override fun onTokenError(exception: Exception) {
        super.onTokenError(exception)
        Log.e(TAG, "Token error: ${exception.message}")
    }
}

