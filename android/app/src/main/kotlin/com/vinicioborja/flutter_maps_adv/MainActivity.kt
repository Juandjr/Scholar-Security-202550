package com.paulogalarza.scholarsecurity

import android.content.Intent
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.paulogalarza.scholarsecurity/notification"
    private var notificationData: String? = null
    private var notificationType: String? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Verificar si la app se abrió desde una notificación
        handleNotificationIntent(intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        handleNotificationIntent(intent)
    }

    private fun handleNotificationIntent(intent: Intent) {
        notificationType = intent.getStringExtra("notification_type")
        notificationData = intent.getStringExtra("notification_data")

        // Si hay datos de notificación, configurar el canal de comunicación con Flutter
        if (notificationType != null && notificationData != null) {
            setupMethodChannel()
        }
    }

    private fun setupMethodChannel() {
        flutterEngine?.dartExecutor?.binaryMessenger?.let { messenger ->
            MethodChannel(messenger, CHANNEL).setMethodCallHandler { call, result ->
                when (call.method) {
                    "getNotificationData" -> {
                        val data = mapOf(
                            "type" to notificationType,
                            "data" to notificationData
                        )
                        result.success(data)

                        // Limpiar los datos después de enviarlos
                        notificationType = null
                        notificationData = null
                    }
                    else -> result.notImplemented()
                }
            }
        }
    }
}
