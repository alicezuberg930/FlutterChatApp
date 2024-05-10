package com.example.flutter_chat_app

import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context

import android.os.Build
import android.view.ViewTreeObserver
import android.view.WindowManager
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {

    private val CHANNEL = "notifications.manage"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
          call, result ->
          // Note: this method is invoked on the main thread.
          // TODO
          if (call.method == "getChannels") {
            val notificationChannels = getNotificationChannels()
            if (notificationChannels != null) {
              result.success(notificationChannels)
            } else {
              result.error("UNAVAILABLE", "No notification channels", null)
            }
          }else if (call.method == "deleteChannel") {
              deleteNotificationChannel(call.argument("id")!!)
              result.success("Notification channel deleted")
          } else {
            result.notImplemented()
          }
        }
      }


      private fun getNotificationChannels(): List<String>? {
        val notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            return notificationManager.notificationChannels.map { it -> "${it.id} -- ${it.name}" }.toList()
        } else {
            null
        }
      }

    private fun deleteNotificationChannel(channelId: String) {
        val notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            notificationManager.deleteNotificationChannel(channelId)
        }
    }
}